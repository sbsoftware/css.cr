require "./function_call"

module CSS
  struct RgbFunctionCall < FunctionCall
    getter red : Int32
    getter green : Int32
    getter blue : Int32
    getter alpha : (Int32 | Float64 | CSS::PercentValue)?
    getter from : String?

    def initialize(@red, @green, @blue, *, @alpha = nil, @from = nil)
    end

    def function_name : String
      "rgb"
    end

    def arguments : String
      String.build do |str|
        if from_value = from
          str << "from "
          str << from_value
          str << " "
        end

        str << red
        str << ", "
        str << green
        str << ", "
        str << blue

        if alpha_value = alpha
          str << ", "
          str << alpha
        end
      end
    end
  end
end
