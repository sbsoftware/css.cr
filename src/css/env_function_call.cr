require "./function_call"
require "./enums/env_variable"

module CSS
  # Represents an `env()` function call with a typed browser environment variable name.
  struct EnvFunctionCall
    include FunctionCall

    getter variable : CSS::Enums::EnvVariable
    getter indices : Array(Int32)
    getter fallback : String?

    def initialize(@variable : CSS::Enums::EnvVariable, fallback = nil)
      @indices = [] of Int32
      @fallback = fallback.nil? ? nil : format(fallback)
      validate_indices
    end

    def initialize(@variable : CSS::Enums::EnvVariable, index1 : Int32, index2 : Int32, fallback = nil)
      @indices = [index1, index2]
      @fallback = fallback.nil? ? nil : format(fallback)
      validate_indices
    end

    def function_name : String
      "env"
    end

    def arguments : String
      String.build do |str|
        str << variable.to_css_value
        indices.each do |index|
          str << " "
          str << index
        end
        if fallback
          str << ", "
          str << fallback
        end
      end
    end

    private def viewport_segment_variable?
      case variable
      when .viewport_segment_width?, .viewport_segment_height?, .viewport_segment_top?, .viewport_segment_right?, .viewport_segment_bottom?, .viewport_segment_left?
        true
      else
        false
      end
    end

    private def validate_indices
      if viewport_segment_variable?
        raise ArgumentError.new("#{variable.to_css_value} requires exactly two non-negative indices") unless indices.size == 2 && indices.all?(&.>= 0)
      elsif !indices.empty?
        raise ArgumentError.new("#{variable.to_css_value} does not accept indices")
      end
    end

    private def format(value) : String
      return value if value.is_a?(String)
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end
end
