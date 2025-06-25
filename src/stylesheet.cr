require "./css/any_selector"
require "./css/string_selector"
require "./css/descendant_selector"
require "./css/child_selector"
require "./css/combined_selector"
require "./css/attr_selector"
require "./css/pseudoclass_selector"
require "./display_value"

module CSS
  class Stylesheet
    macro rule(selector_expression, &blk)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        make_rule(io, make_selector({{selector_expression}})) {{blk}}
      end
    end

    macro make_selector(expr, nested = false)
      {% if expr.is_a?(Call) && expr.name == "any".id %}
        CSS::AnySelector.new
      {% elsif expr.is_a?(Call) && CSS::HTML_TAG_NAMES.includes?(expr.name.stringify) %}
        CSS::StringSelector.new({{expr.name.stringify}})
      {% elsif expr.is_a?(Call) && expr.name == "<=".id %}
        CSS::PseudoclassSelector.new(make_selector({{expr.receiver}}), {{expr.args.first.expressions.last}})
      {% elsif expr.is_a?(Call) && expr.name == "&&".id %}
        make_selector({{expr.receiver}}).combine(make_selector({{expr.args.first}}))
      {% elsif expr.is_a?(And) %}
        # This will occurr when multiple `>` calls are concatenated.
        # The Crystal compiler transforms `x > y > z` into `x > (__temp_136 = y) && __temp_136 > z`
        make_selector({{expr.left}}).combine(make_selector({{expr.right}}, true))
      {% elsif expr.is_a?(Assign) %}
        # This can occur via Crystal's internal transformations of `x > y > z`, for example
        make_selector({{expr.value}})
      {% elsif expr.is_a?(Call) && expr.name == ">".id %}
        {% if nested %}
          CSS::NestedChildSelector.new(make_selector({{expr.args.first}}))
        {% else %}
          CSS::ChildSelector.new(make_selector({{expr.receiver}}), make_selector({{expr.args.first}}))
        {% end %}
      {% elsif expr.is_a?(Expressions) %}
        make_selector({{expr.expressions.last}})
      {% else %}
        {{expr}}.to_css_selector
      {% end %}
    end

    macro make_rule(io, selector, &blk)
      %child_rules = String.build do |%child_rule_io|
        {{io}} << {{selector}}
        {{io}} << " {\n"
        {% if blk.body.is_a?(Expressions) %}
          {% for exp in blk.body.expressions %}
            {% if exp.is_a?(Call) && exp.name.stringify == "rule" && exp.args.size == 1 && exp.block %}
              make_rule(%child_rule_io, CSS::DescendantSelector.new({{selector}}, make_selector({{exp.args.first}}))) {{exp.block}}
            {% else %}
              {{io}} << "  "
              {{io}} << {{exp}}
            {% end %}
          {% end %}
        {% else %}
          {% if blk.body.is_a?(Call) && blk.body.name.stringify == "rule" && blk.body.args.size == 1 && blk.body.block %}
            make_rule(%child_rule_io, CSS::DescendantSelector.new({{selector}}, make_selector({{blk.body.args.first}}))) {{blk.body.block}}
          {% else %}
            {{io}} << "  "
            {{io}} << {{blk.body}}
          {% end %}
        {% end %}
        {{io}} << "\n}"
      end

      if %child_rules.size.positive?
        {{io}} << "\n\n"
        {{io}} << %child_rules
      end
    end

    def self.display(value : CSS::DisplayValue)
      prop("display", value)
    end

    def self.prop(name, value)
      "#{name}: #{value.to_s.underscore.gsub(/_/, "-")};"
    end
  end
end
