require "./function_call"

module CSS
  alias HslHue = Int32 | Float32 | Float64
  alias HslAlpha = Int32 | Float32 | Float64 | CSS::PercentValue

  struct HslFunctionCall
    include FunctionCall
    getter hue : HslHue
    getter saturation : CSS::PercentValue
    getter lightness : CSS::PercentValue

    def initialize(@hue, @saturation, @lightness)
      validate_hsl_values
    end

    def function_name : String
      "hsl"
    end

    def arguments : String
      "#{hue}, #{saturation}, #{lightness}"
    end

    private def validate_hsl_values
      raise ArgumentError.new("hue must be between 0 and 360") unless 0 <= hue <= 360
      raise ArgumentError.new("saturation must be between 0% and 100%") unless 0 <= saturation.value <= 100
      raise ArgumentError.new("lightness must be between 0% and 100%") unless 0 <= lightness.value <= 100
    end
  end

  struct HslaFunctionCall
    include FunctionCall
    getter alpha : HslAlpha

    def initialize(hue, saturation, lightness, @alpha)
      @hsl = HslFunctionCall.new(hue, saturation, lightness)
      validate_alpha
    end

    def hue : HslHue
      hsl.hue
    end

    def saturation : CSS::PercentValue
      hsl.saturation
    end

    def lightness : CSS::PercentValue
      hsl.lightness
    end

    def function_name : String
      "hsla"
    end

    def arguments : String
      "#{hsl.arguments}, #{alpha}"
    end

    private getter hsl : HslFunctionCall

    private def validate_alpha
      alpha_value = alpha

      if alpha_value.is_a?(CSS::PercentValue)
        raise ArgumentError.new("alpha must be between 0% and 100%") unless 0 <= alpha_value.value <= 100
      else
        raise ArgumentError.new("alpha must be between 0 and 1") unless 0 <= alpha_value <= 1
      end
    end
  end
end
