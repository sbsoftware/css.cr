require "./function_call"
require "./calculation"

module CSS
  struct CalcFunctionCall < FunctionCall
    getter calculation : Calculation

    def initialize(@calculation)
    end

    def function_name : String
      "calc"
    end

    def arguments : String
      calculation.expression
    end
  end
end
