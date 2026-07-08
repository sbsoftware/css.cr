require "./filter_function_call"

module CSS
  module FilterFunctions
    macro dispatch(value)
      {% if value.is_a?(SymbolLiteral) && value.id == :none %}
        CSS::Enums::None::None
      {% elsif value.is_a?(Call) %}
        CSS::FilterFunctions.{{value.name}}({{value.args.splat}})
      {% else %}
        {{value}}
      {% end %}
    end

    macro blur(radius = nil)
      {% if radius && radius.is_a?(NumberLiteral) && radius != 0 %}
        {{ radius.raise "Non-zero number values have to be specified with a unit, for example: #{radius}.px" }}
      {% end %}

      {% if radius %}
        CSS::FilterFunctions._blur({{radius}})
      {% else %}
        CSS::FilterFunctions._blur
      {% end %}
    end

    def self._blur(radius : CSS::Length? = nil)
      radius ? FilterFunctionCall.new("blur", radius) : FilterFunctionCall.new("blur")
    end

    def self.brightness(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("brightness", amount) : FilterFunctionCall.new("brightness")
    end

    def self.contrast(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("contrast", amount) : FilterFunctionCall.new("contrast")
    end

    def self.drop_shadow(*values)
      FilterFunctionCall.new("drop-shadow", values)
    end

    def self.grayscale(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("grayscale", amount) : FilterFunctionCall.new("grayscale")
    end

    def self.hue_rotate(angle : CSS::Angle? = nil)
      angle ? FilterFunctionCall.new("hue-rotate", angle) : FilterFunctionCall.new("hue-rotate")
    end

    def self.invert(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("invert", amount) : FilterFunctionCall.new("invert")
    end

    def self.opacity(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("opacity", amount) : FilterFunctionCall.new("opacity")
    end

    def self.saturate(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("saturate", amount) : FilterFunctionCall.new("saturate")
    end

    def self.sepia(amount : CSS::NumberPercentage? = nil)
      amount ? FilterFunctionCall.new("sepia", amount) : FilterFunctionCall.new("sepia")
    end
  end
end
