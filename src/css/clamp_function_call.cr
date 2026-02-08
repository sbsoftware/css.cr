require "./function_call"

module CSS
  # Represents a `clamp()` function call.
  #
  # Typically used with length/percentage values (for example for responsive font sizes).
  struct ClampFunctionCall
    include FunctionCall

    getter min : String
    getter preferred : String
    getter max : String

    def initialize(min, preferred, max)
      @min = format(min)
      @preferred = format(preferred)
      @max = format(max)
    end

    def function_name : String
      "clamp"
    end

    def arguments : String
      "#{min}, #{preferred}, #{max}"
    end

    private def format(value) : String
      return value if value.is_a?(String)
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end
end
