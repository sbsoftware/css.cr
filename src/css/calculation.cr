module CSS
  class Calculation
    getter left : CalcOperand
    getter right : CalcOperand
    getter operator : String | Symbol

    def initialize(@left : CalcOperand, @operator : String | Symbol, @right : CalcOperand)
    end

    def expression
      "#{operand_value(left)} #{operator} #{operand_value(right)}"
    end

    # Pure calculation, wrapped to preserve precedence when embedded.
    def to_css_value
      "(#{expression})"
    end

    def +(other : CalcOperand)
      Calculation.new(self, "+", other)
    end

    def -(other : CalcOperand)
      Calculation.new(self, "-", other)
    end

    def *(other : CalcOperand)
      Calculation.new(self, "*", other)
    end

    def /(other : CalcOperand)
      Calculation.new(self, "/", other)
    end

    private def operand_value(operand)
      operand.to_css_value
    end
  end
end
