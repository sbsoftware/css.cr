require "http/client"
require "json"
require "set"

PROPERTIES_URL      = "https://raw.githubusercontent.com/mdn/data/refs/heads/main/css/properties.json"
STYLESHEET_PATH     = "src/stylesheet.cr"
ENUMS_GLOB          = "src/css/enums/*.cr"
DEFAULT_OUTPUT_PATH = "COVERAGE.md"

class MdnPropertyDefinition
  include JSON::Serializable

  getter status : String?
  getter syntax : String?
end

class LocalPropertyCoverage
  getter enum_names : Set(String)
  property has_enum : Bool
  property has_raw_string : Bool
  property has_transformed_string : Bool
  property has_non_string_input : Bool

  def initialize
    @has_enum = false
    @has_raw_string = false
    @has_transformed_string = false
    @has_non_string_input = false
    @enum_names = Set(String).new
  end

  def observe_macro_signature(macro_name : String, rest : String)
    type_count = macro_name == "prop" ? 1 : macro_name.lchop("prop").to_i
    parts = rest.split(",").map(&.strip)
    type_expressions = parts.first(type_count)
    options = parts.skip(type_count).join(",")
    has_transform = !!(options =~ /\btransform_string\d*\s*:/)

    type_expressions.each do |expr|
      observe_type_expression(expr, has_transform)
    end
  end

  def observe_runtime_signature(signature : String)
    @has_enum ||= signature.includes?("CSS::Enums::")

    signature.scan(/CSS::Enums::([A-Za-z0-9_]+)/) do |match|
      @enum_names << match[1]
    end

    if signature =~ /\bString\b/
      @has_raw_string = true
    else
      @has_non_string_input = true
    end
  end

  def raw_string_only? : Bool
    @has_raw_string && !@has_transformed_string && !@has_non_string_input
  end

  private def observe_type_expression(expr : String, has_transform : Bool)
    @has_enum ||= expr.includes?("CSS::Enums::")

    expr.scan(/CSS::Enums::([A-Za-z0-9_]+)/) do |match|
      @enum_names << match[1]
    end

    has_string = !!(expr =~ /\bString\b/)

    if has_string
      if has_transform
        @has_transformed_string = true
      else
        @has_raw_string = true
      end
    end

    expr_without_string = expr.gsub(/\bString\b/, " ").gsub(/[|\s]/, "")
    @has_non_string_input ||= !expr_without_string.empty?
  end
end

record CoverageRow,
  property : String,
  property_status : String,
  property_note : String,
  enum_status : String,
  enum_note : String,
  syntax : String

def method_name_to_property(name : String) : String
  if name.starts_with?('_')
    "-#{name.lchop('_').gsub('_', '-')}"
  else
    name.gsub('_', '-')
  end
end

def parse_local_property_coverage(stylesheet_path : String) : Hash(String, LocalPropertyCoverage)
  coverage = Hash(String, LocalPropertyCoverage).new do |hash, key|
    hash[key] = LocalPropertyCoverage.new
  end

  File.each_line(stylesheet_path) do |line|
    if match = line.match(/^\s*(prop\d?)\s+([a-z0-9_]+)\s*,\s*(.+?)\s*(?:#.*)?$/)
      macro_name = match[1]
      property = method_name_to_property(match[2])
      rest = match[3]
      coverage[property].observe_macro_signature(macro_name, rest)
      next
    end

    if line.includes?("def self._grid_template_rows(")
      coverage["grid-template-rows"].observe_runtime_signature(line)
      next
    end

    if line.includes?("def self._grid_template_columns(")
      coverage["grid-template-columns"].observe_runtime_signature(line)
      next
    end

    if line.includes?("def self._transform(")
      coverage["transform"].observe_runtime_signature(line)
      next
    end
  end

  coverage
end

def parse_local_enum_names : Set(String)
  enum_names = Set(String).new

  Dir.glob(ENUMS_GLOB).sort!.each do |path|
    File.each_line(path) do |line|
      next unless match = line.match(/^\s*css_enum\s+([A-Za-z0-9_]+)\s+do\s*$/)
      enum_names << match[1]
      break
    end
  end

  enum_names
end

def property_status_and_note(local : LocalPropertyCoverage?) : {String, String}
  return {"missing", "property not implemented"} unless local

  if local.raw_string_only?
    {"unsupported", "raw String-only overloads emit quoted values"}
  elsif local.has_raw_string
    {"supported", "typed overloads exist; raw String fallback may quote values"}
  else
    {"supported", "typed overloads"}
  end
end

def enum_status_and_note(local : LocalPropertyCoverage?) : {String, String}
  return {"n/a", "not evaluated because property is missing"} unless local

  if local.has_enum
    if local.has_raw_string
      {"partial", "typed enums exist; raw String fallback remains"}
    else
      {"supported", "typed enums"}
    end
  else
    {"n/a", "not tracked as a required enum gap"}
  end
end

def normalize_syntax(syntax : String?) : String
  return "-" unless syntax
  syntax.gsub(/\s+/, " ").strip
end

def markdown_table_row(values : Array(String)) : String
  "| #{values.map { |value|
       value
         .gsub("&", "&amp;")
         .gsub("<", "&lt;")
         .gsub(">", "&gt;")
         .gsub("|", "\\|")
     }.join(" | ")} |"
end

def generate_report(
  output_path : String,
  rows : Array(CoverageRow),
  local_properties : Hash(String, LocalPropertyCoverage),
  local_enum_names : Set(String),
  total_mdn_properties : Int32,
)
  property_supported_count = rows.count { |row| row.property_status == "supported" }
  property_unsupported_count = rows.count { |row| row.property_status == "unsupported" }
  property_missing_count = rows.count { |row| row.property_status == "missing" }

  enum_applicable_rows = rows.select { |row| row.enum_status != "n/a" }
  enum_supported_count = enum_applicable_rows.count { |row| row.enum_status == "supported" }
  enum_partial_count = enum_applicable_rows.count { |row| row.enum_status == "partial" }
  enum_na_count = rows.count { |row| row.enum_status == "n/a" }

  missing_rows = rows.select { |row| row.property_status == "missing" }
  unsupported_rows = rows.select { |row| row.property_status == "unsupported" }

  enum_gap_rows = enum_applicable_rows.select { |row| row.enum_status != "supported" }

  local_only_properties = local_properties.keys.reject { |property| rows.any? { |row| row.property == property } }.sort

  enum_to_properties = Hash(String, Set(String)).new do |hash, key|
    hash[key] = Set(String).new
  end

  local_properties.each do |property, coverage|
    coverage.enum_names.each do |enum_name|
      enum_to_properties[enum_name] << property
    end
  end

  enum_rows = local_enum_names.to_a.sort.map do |enum_name|
    references = enum_to_properties[enum_name]
    status = references.empty? ? "unused" : "used"
    reference_list = references.to_a.sort.join(", ")
    {enum_name, status, reference_list.empty? ? "-" : reference_list}
  end

  generated_at = Time.utc.to_s("%Y-%m-%d %H:%M UTC")

  report = String.build do |io|
    io.puts "# CSS Coverage Index"
    io.puts
    io.puts "Generated by `crystal scripts/generate_coverage.cr` on #{generated_at}."
    io.puts
    io.puts "Data sources:"
    io.puts "- MDN properties data: `#{PROPERTIES_URL}` (standard, non-prefixed properties only)"
    io.puts "- Local property definitions: `#{STYLESHEET_PATH}`"
    io.puts "- Local enums: `#{ENUMS_GLOB}`"
    io.puts
    io.puts "Status legend:"
    io.puts "- Property `supported`: property has at least one typed/non-raw-string path"
    io.puts "- Property `unsupported`: property exists but only raw `String` overloads are available"
    io.puts "- Property `missing`: property is not implemented in `CSS::Stylesheet`"
    io.puts "- Enum `supported/partial`: reported only for enum-applicable properties"
    io.puts "- Enum `n/a`: enum gap is not inferred for that property"
    io.puts "- `unsupported` properties should be treated as implementation gaps and migrated to typed/wrapped inputs"
    io.puts
    io.puts "## Summary"
    io.puts
    io.puts markdown_table_row(["Metric", "Count"])
    io.puts markdown_table_row(["---", "---"])
    io.puts markdown_table_row(["MDN standard properties", total_mdn_properties.to_s])
    io.puts markdown_table_row(["Properties: supported", property_supported_count.to_s])
    io.puts markdown_table_row(["Properties: unsupported", property_unsupported_count.to_s])
    io.puts markdown_table_row(["Properties: missing", property_missing_count.to_s])
    io.puts markdown_table_row(["Enum-applicable properties", enum_applicable_rows.size.to_s])
    io.puts markdown_table_row(["Enum coverage: supported", enum_supported_count.to_s])
    io.puts markdown_table_row(["Enum coverage: partial", enum_partial_count.to_s])
    io.puts markdown_table_row(["Enum coverage: n/a", enum_na_count.to_s])
    io.puts
    io.puts "## Missing Properties"
    io.puts

    if missing_rows.empty?
      io.puts "No missing MDN standard properties."
    else
      io.puts markdown_table_row(["Property"])
      io.puts markdown_table_row(["---"])
      missing_rows.each do |row|
        io.puts markdown_table_row([row.property])
      end
    end

    io.puts
    io.puts "## Unsupported String-Only Properties"
    io.puts
    io.puts "These properties are currently not practically usable and need implementation with typed or wrapped value paths."
    io.puts

    if unsupported_rows.empty?
      io.puts "None."
    else
      io.puts markdown_table_row(["Property", "MDN Syntax"])
      io.puts markdown_table_row(["---", "---"])
      unsupported_rows.each do |row|
        io.puts markdown_table_row([row.property, row.syntax])
      end
    end

    io.puts
    io.puts "## Enum Coverage Gaps (Enum-Applicable Properties Only)"
    io.puts

    if enum_gap_rows.empty?
      io.puts "No enum coverage gaps for enum-applicable properties."
    else
      io.puts markdown_table_row(["Property", "Enum Status", "Enum Note"])
      io.puts markdown_table_row(["---", "---", "---"])
      enum_gap_rows.each do |row|
        io.puts markdown_table_row([row.property, row.enum_status, row.enum_note])
      end
    end

    io.puts
    io.puts "## Local-Only Properties (Not In MDN Standard Set)"
    io.puts

    if local_only_properties.empty?
      io.puts "None."
    else
      io.puts markdown_table_row(["Property"])
      io.puts markdown_table_row(["---"])
      local_only_properties.each do |property|
        io.puts markdown_table_row([property])
      end
    end

    io.puts
    io.puts "## Enum Inventory"
    io.puts
    io.puts markdown_table_row(["Enum", "Status", "Referenced Properties"])
    io.puts markdown_table_row(["---", "---", "---"])
    enum_rows.each do |row|
      io.puts markdown_table_row(row.to_a)
    end

    io.puts
    io.puts "## Full Property + Enum Coverage Index"
    io.puts
    io.puts markdown_table_row(["Property", "Property Status", "Property Note", "Enum Status", "Enum Note", "MDN Syntax"])
    io.puts markdown_table_row(["---", "---", "---", "---", "---", "---"])
    rows.each do |row|
      io.puts markdown_table_row([
        row.property,
        row.property_status,
        row.property_note,
        row.enum_status,
        row.enum_note,
        row.syntax,
      ])
    end

    io.puts
    io.puts "## How To Add Missing CSS"
    io.puts
    io.puts "1. Add property overloads in `src/stylesheet.cr` with `prop`, `prop2`, ... and include typed inputs (avoid raw `String`-only overloads)."
    io.puts "2. For keyword-heavy properties, add `css_enum` values in `src/css/enums/*.cr` and use `CSS::Enums::*` types in property signatures."
    io.puts "3. For free-form values that should not be quoted, use `transform_string` to map `String` to a custom wrapper with `to_css_value`."
    io.puts "4. Add focused specs in `spec/*_spec.cr` for rendered CSS output and at least one typed path."
    io.puts "5. Regenerate this index: `crystal scripts/generate_coverage.cr`."
    io.puts
    io.puts "## Contribution Checklist"
    io.puts
    io.puts "- [ ] Property method added to `CSS::Stylesheet`."
    io.puts "- [ ] Enum(s) added/updated under `src/css/enums/` when MDN keywords should be typed."
    io.puts "- [ ] Raw `String`-only property signatures removed or replaced with typed/wrapped inputs."
    io.puts "- [ ] Specs added/updated under `spec/`."
    io.puts "- [ ] `crystal spec` run."
    io.puts "- [ ] Coverage index regenerated with `crystal scripts/generate_coverage.cr`."
  end

  Dir.mkdir_p(File.dirname(output_path))
  File.write(output_path, report)
end

output_path = ARGV[0]? || DEFAULT_OUTPUT_PATH
local_properties = parse_local_property_coverage(STYLESHEET_PATH)
local_enum_names = parse_local_enum_names

response = HTTP::Client.get(PROPERTIES_URL)
unless response.status_code == 200
  STDERR.puts "Failed to fetch MDN properties: HTTP #{response.status_code}"
  exit 1
end

mdn_properties = Hash(String, MdnPropertyDefinition).from_json(response.body)
standard_mdn_properties = mdn_properties
  .select { |name, definition| !name.starts_with?('-') && definition.status == "standard" }
  .keys
  .sort

rows = standard_mdn_properties.map do |property|
  local = local_properties[property]?
  property_status, property_note = property_status_and_note(local)
  enum_status, enum_note = enum_status_and_note(local)
  syntax = normalize_syntax(mdn_properties[property]?.try(&.syntax))

  CoverageRow.new(
    property: property,
    property_status: property_status,
    property_note: property_note,
    enum_status: enum_status,
    enum_note: enum_note,
    syntax: syntax
  )
end

generate_report(
  output_path: output_path,
  rows: rows,
  local_properties: local_properties,
  local_enum_names: local_enum_names,
  total_mdn_properties: standard_mdn_properties.size
)

puts "Generated #{output_path} (#{rows.size} MDN properties analyzed)."
