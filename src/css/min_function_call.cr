require "./function_call"

module CSS
  # Represents a `min()` function call.
  struct MinFunctionCall
    include FunctionCall

    getter arguments : String

    def initialize(*values)
      @arguments = build_arguments(values)
    end

    def function_name : String
      "min"
    end

    private def build_arguments(values : Tuple) : String
      values.map { |value| format(value) }.join(", ")
    end

    private def format(value) : String
      return value if value.is_a?(String)
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end
end
