{% for unit_name in ["cm", "mm", "in", "px", "pt", "pc", "em", "rem", "ex", "ch", "lh", "rlh", "vh", "vw", "vmax", "vmin", "svw", "svh", "lvw", "lvh", "dvw", "dvh", "deg", "rad", "grad", "turn", "Hz", "kHz", "dpi", "dpcm", "dppx", "fr"] %}
  module CSS
    struct {{unit_name.capitalize.id}}Value
      getter value : (Int8 | Int16 | Int32 | Int128 | Float32 | Float64)

      def initialize(@value); end

      def to_s(io : IO)
        io << value
        io << {{unit_name}}
      end

      def to_css_value
        to_s
      end

      def +(other : self)
        self.class.new(value + other.value)
      end

      def +(other : Number)
        self.class.new(value + other)
      end

      def -(other : self)
        self.class.new(value - other.value)
      end

      def -(other : Number)
        self.class.new(value - other)
      end

      def +(other : CSS::CalcOperand)
        CSS::Calculation.new(self, "+", other)
      end

      def -(other : CSS::CalcOperand)
        CSS::Calculation.new(self, "-", other)
      end

      def *(other : CSS::CalcOperand)
        CSS::Calculation.new(self, "*", other)
      end

      def /(other : CSS::CalcOperand)
        CSS::Calculation.new(self, "/", other)
      end

      def *(other : Number)
        self.class.new(value * other)
      end

      def /(other : Number)
        self.class.new(value / other)
      end

      def -
        self.class.new(-value)
      end
    end
  end

  {% for number_struct in [Int8, Int16, Int32, Int64, Float32, Float64] %}
    struct {{number_struct}}
      def {{unit_name.downcase.id}}
        CSS::{{unit_name.capitalize.id}}Value.new(self)
      end

      def *(value : CSS::{{unit_name.capitalize.id}}Value)
        value * self
      end
    end
  {% end %}
{% end %}

# Special case: percent
# Method name is different from output symbol "%"
module CSS
  struct PercentValue
    getter value : (Int8 | Int16 | Int32 | Int128 | Float32 | Float64)

    def initialize(@value); end

    def to_s(io : IO)
      io << value
      io << "%"
    end

    def to_css_value
      to_s
    end

    def +(other : PercentValue)
      PercentValue.new(value + other.value)
    end

    def +(other : Number)
      PercentValue.new(value + other)
    end

    def -(other : PercentValue)
      PercentValue.new(value - other.value)
    end

    def -(other : Number)
      PercentValue.new(value - other)
    end

    def *(other : Number)
      PercentValue.new(value * other)
    end

    def /(other : Number)
      PercentValue.new(value / other)
    end

    def -
      PercentValue.new(-value)
    end

    def +(other : CSS::CalcOperand)
      CSS::Calculation.new(self, "+", other)
    end

    def -(other : CSS::CalcOperand)
      CSS::Calculation.new(self, "-", other)
    end

    def *(other : CSS::CalcOperand)
      CSS::Calculation.new(self, "*", other)
    end

    def /(other : CSS::CalcOperand)
      CSS::Calculation.new(self, "/", other)
    end
  end
end

{% for number_struct in [Int8, Int16, Int32, Int64, Float32, Float64] %}
  struct {{number_struct}}
    def percent
      CSS::PercentValue.new(self)
    end

    def *(value : CSS::PercentValue)
      value * self
    end

    def +(value : CSS::CalcNonNumeric)
      CSS::Calculation.new(self, "+", value)
    end

    def -(value : CSS::CalcNonNumeric)
      CSS::Calculation.new(self, "-", value)
    end

    def *(value : CSS::CalcNonNumeric)
      CSS::Calculation.new(self, "*", value)
    end

    def /(value : CSS::CalcNonNumeric)
      CSS::Calculation.new(self, "/", value)
    end
  end
{% end %}

module CSS
  alias CalcNumeric = Int8 | Int16 | Int32 | Int64 | Int128 | Float32 | Float64
  alias CalcUnit = CmValue | MmValue | InValue | PxValue | PtValue | PcValue | EmValue | RemValue | ExValue | ChValue | LhValue | RlhValue | VhValue | VwValue | VmaxValue | VminValue | SvwValue | LvwValue | LvhValue | DvwValue | DvhValue | FrValue
  alias CalcOperand = CalcNumeric | PercentValue | CalcUnit | Calculation | CalcFunctionCall
  alias CalcNonNumeric = Calculation | PercentValue | CalcUnit | CalcFunctionCall

  alias Length = CmValue | MmValue | InValue | PxValue | PtValue | PcValue | EmValue | RemValue | ExValue | ChValue | LhValue | RlhValue | VhValue | VwValue | VmaxValue | VminValue | SvwValue | LvwValue | LvhValue | DvwValue | DvhValue | FrValue | Int32 | CalcFunctionCall | ClampFunctionCall
  alias LengthPercentage = Length | PercentValue | CalcFunctionCall
  alias Angle = DegValue | RadValue | GradValue | TurnValue | CalcFunctionCall | ClampFunctionCall
  alias NumberPercentage = Int32 | Float32 | PercentValue | CalcFunctionCall | ClampFunctionCall
end
