require "./transform_function_call"

module CSS
  module TransformFunctions
    macro dispatch(value)
      {% if value.is_a?(SymbolLiteral) && value.id == :none %}
        CSS::Enums::None::None
      {% elsif value.is_a?(Call) %}
        CSS::TransformFunctions.{{value.name}}({{value.args.splat}})
      {% else %}
        {{value}}
      {% end %}
    end

    macro perspective(distance)
      {% if distance.is_a?(NumberLiteral) && distance != 0 %}
        {{ distance.raise "Non-zero number values have to be specified with a unit, for example: #{distance}.px" }}
      {% end %}

      CSS::TransformFunctions._perspective({{distance}})
    end

    def self._perspective(distance : CSS::Length)
      TransformFunctionCall.new("perspective", distance)
    end

    def self.scale(x : Number, y : Number? = nil)
      values = y ? {x, y} : {x}
      TransformFunctionCall.new("scale", values)
    end

    def self.scale_x(x : Number)
      TransformFunctionCall.new("scaleX", x)
    end

    def self.scale_y(y : Number)
      TransformFunctionCall.new("scaleY", y)
    end

    def self.scale_z(z : Number)
      TransformFunctionCall.new("scaleZ", z)
    end

    def self.scale3d(x : Number, y : Number, z : Number)
      TransformFunctionCall.new("scale3d", {x, y, z})
    end

    macro translate(x, y = nil)
      {% if x.is_a?(NumberLiteral) && x != 0 %}
        {{ x.raise "Non-zero number values have to be specified with a unit, for example: #{x}.px" }}
      {% end %}
      {% if y && y.is_a?(NumberLiteral) && y != 0 %}
        {{ y.raise "Non-zero number values have to be specified with a unit, for example: #{y}.px" }}
      {% end %}

      {% if y %}
        CSS::TransformFunctions._translate({{x}}, {{y}})
      {% else %}
        CSS::TransformFunctions._translate({{x}})
      {% end %}
    end

    def self._translate(x : CSS::LengthPercentage, y : CSS::LengthPercentage? = nil)
      y ? TransformFunctionCall.new("translate", x, y) : TransformFunctionCall.new("translate", x)
    end

    macro translate_x(x)
      {% if x.is_a?(NumberLiteral) && x != 0 %}
        {{ x.raise "Non-zero number values have to be specified with a unit, for example: #{x}.px" }}
      {% end %}

      CSS::TransformFunctions._translate_x({{x}})
    end

    def self._translate_x(x : CSS::LengthPercentage)
      TransformFunctionCall.new("translateX", x)
    end

    macro translate_y(y)
      {% if y.is_a?(NumberLiteral) && y != 0 %}
        {{ y.raise "Non-zero number values have to be specified with a unit, for example: #{y}.px" }}
      {% end %}

      CSS::TransformFunctions._translate_y({{y}})
    end

    def self._translate_y(y : CSS::LengthPercentage)
      TransformFunctionCall.new("translateY", y)
    end

    macro translate_z(z)
      {% if z.is_a?(NumberLiteral) && z != 0 %}
        {{ z.raise "Non-zero number values have to be specified with a unit, for example: #{z}.px" }}
      {% end %}

      CSS::TransformFunctions._translate_z({{z}})
    end

    def self._translate_z(z : CSS::Length)
      TransformFunctionCall.new("translateZ", z)
    end

    macro translate3d(x, y, z)
      {% if x.is_a?(NumberLiteral) && x != 0 %}
        {{ x.raise "Non-zero number values have to be specified with a unit, for example: #{x}.px" }}
      {% end %}
      {% if y.is_a?(NumberLiteral) && y != 0 %}
        {{ y.raise "Non-zero number values have to be specified with a unit, for example: #{y}.px" }}
      {% end %}
      {% if z.is_a?(NumberLiteral) && z != 0 %}
        {{ z.raise "Non-zero number values have to be specified with a unit, for example: #{z}.px" }}
      {% end %}

      CSS::TransformFunctions._translate3d({{x}}, {{y}}, {{z}})
    end

    def self._translate3d(x : CSS::LengthPercentage, y : CSS::LengthPercentage, z : CSS::Length)
      TransformFunctionCall.new("translate3d", {x, y, z})
    end

    def self.rotate(angle : CSS::Angle)
      TransformFunctionCall.new("rotate", angle)
    end

    def self.rotate3d(x : Number, y : Number, z : Number, angle : CSS::Angle)
      TransformFunctionCall.new("rotate3d", {x, y, z, angle})
    end

    def self.rotate_x(angle : CSS::Angle)
      TransformFunctionCall.new("rotateX", angle)
    end
    def self.rotate_y(angle : CSS::Angle)
      TransformFunctionCall.new("rotateY", angle)
    end
    def self.rotate_z(angle : CSS::Angle)
      TransformFunctionCall.new("rotateZ", angle)
    end

    def self.skew(x : CSS::Angle, y : CSS::Angle? = nil)
      values = y ? {x, y} : {x}
      TransformFunctionCall.new("skew", values)
    end

    def self.skew_x(x : CSS::Angle)
      TransformFunctionCall.new("skewX", x)
    end

    def self.skew_y(y : CSS::Angle)
      TransformFunctionCall.new("skewY", y)
    end

    def self.matrix(a : Number, b : Number, c : Number, d : Number, e : Number, f : Number)
      TransformFunctionCall.new("matrix", {a, b, c, d, e, f})
    end

    macro matrix3d(*values)
      {% if values.size != 16 %}
        {{ values.raise "matrix3d requires 16 values (got #{values.size})" }}
      {% end %}

      CSS::TransformFunctions._matrix3d({{values.splat}})
    end

    def self._matrix3d(*values : Number)
      TransformFunctionCall.new("matrix3d", values)
    end
  end
end
