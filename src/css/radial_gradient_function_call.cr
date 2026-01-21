require "./function_call"

module CSS
  # Represents a `radial-gradient()` function call.
  #
  # Values are passed as a splat. Each positional argument becomes a
  # comma-separated segment. To group multiple tokens inside a single
  # segment (e.g. a color stop like `red 10%`), pass a `Tuple`; its items
  # are joined with spaces.
  struct RadialGradientFunctionCall
    include FunctionCall
    getter arguments : String

    def initialize(*values)
      @arguments = build_arguments(values)
    end

    def function_name : String
      "radial-gradient"
    end

    private def build_arguments(values : Tuple) : String
      values.map { |value| normalize(value) }.join(", ")
    end

    private def normalize(value) : String
      case value
      when Tuple
        value.map { |item| format(item) }.join(" ")
      else
        format(value)
      end
    end

    private def format(value) : String
      if value.is_a?(String)
        return value
      elsif value.is_a?(Symbol)
        return value.to_s.gsub("_", "-")
      end
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end
end
