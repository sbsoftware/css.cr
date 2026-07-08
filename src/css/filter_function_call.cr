require "./function_call"
require "./color_string"

module CSS
  # Represents a CSS filter function call such as blur() or drop-shadow().
  struct FilterFunctionCall
    include FunctionCall
    getter function_name : String
    getter arguments : String

    def initialize(@function_name : String, *values)
      @arguments = format_arguments(values)
    end

    def initialize(@function_name : String, values : Enumerable)
      @arguments = format_arguments(values)
    end

    private def format_arguments(values : Enumerable)
      values.map { |value| format_argument(value) }.join(" ")
    end

    private def format_argument(value)
      case value
      when String
        CSS::ColorString.new(value).to_css_value
      when Symbol
        value.to_s.gsub(/_/, "-")
      else
        value.to_css_value
      end
    end
  end
end
