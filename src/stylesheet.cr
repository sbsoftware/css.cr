require "./css/any_selector"
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

    macro make_selector(expr)
      {% if expr.is_a?(Call) && expr.name == "any".id %}
        AnySelector.new
      {% elsif expr.is_a?(Call) %}
        {{expr.name.stringify}}
      {% else %}
        {% raise "Unknown selector expression type #{expr.class.name}" %}
      {% end %}
    end

    macro make_rule(io, selector, &blk)
      %child_rules = String.build do |%child_rule_io|
        {{io}} << {{selector}}
        {{io}} << " {\n"
        {% if blk.body.is_a?(Expressions) %}
          {% for exp in blk.body.expressions %}
            {% if exp.is_a?(Call) && exp.name.stringify == "rule" && exp.args.size == 1 && exp.block %}
              make_rule(%child_rule_io, {{selector}} + " " + make_selector({{exp.args.first}})) {{exp.block}}
            {% else %}
              {{io}} << "  "
              {{io}} << {{exp}}
            {% end %}
          {% end %}
        {% else %}
          {% if blk.body.is_a?(Call) && blk.body.name.stringify == "rule" && blk.body.args.size == 1 && blk.body.block %}
            make_rule(%child_rule_io, {{selector}} + " " + make_selector({{blk.body.args.first}})) {{blk.body.block}}
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
