module CSS
  alias RatioNumber = Int8 | Int16 | Int32 | Int64 | Int128 | Float32 | Float64

  struct Ratio
    getter numerator : RatioNumber
    getter denominator : RatioNumber?

    def initialize(@numerator : RatioNumber, @denominator : RatioNumber? = nil)
    end

    def to_css_value
      String.build do |str|
        str << numerator
        if denom = denominator
          str << " / "
          str << denom
        end
      end
    end
  end
end
