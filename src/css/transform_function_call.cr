require "./function_call"

module CSS
  # Represents a CSS transform function call such as rotateX() or translate().
  struct TransformFunctionCall < FunctionCall
    getter function_name : String
    getter arguments : String

    def initialize(@function_name : String, *values)
      @arguments = format_arguments(values)
    end

    def initialize(@function_name : String, values : Enumerable)
      @arguments = format_arguments(values)
    end

    private def format_arguments(values : Enumerable)
      values.map(&.to_css_value).join(", ")
    end
  end
end
