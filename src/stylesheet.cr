require "./display_value"

module CSS
  class Stylesheet
    macro rule(selector_expression, &blk)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        io << make_selector({{selector_expression}})
        io << " {\n"
        {% if blk.body.is_a?(Expressions) %}
          {% for exp in blk.body.expressions %}
            io << "  "
            io << {{exp}}
          {% end %}
        {% else %}
          io << "  "
          io << {{blk.body}}
        {% end %}
        io << "\n}"
      end
    end

    macro make_selector(expr)
      {% if expr.is_a?(Call) %}
        {{expr.name.stringify}}
      {% else %}
        {% raise "Unknown selector expression type #{expr.class.name}" %}
      {% end %}
    end

    def self.display(value : CSS::DisplayValue)
      prop("display", value)
    end

    def self.prop(name, value)
      "#{name}: #{value.to_s.underscore.gsub(/_/, "-")};"
    end
  end
end
