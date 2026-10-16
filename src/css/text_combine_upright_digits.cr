module CSS
  alias TextCombineUprightDigitCount = Int8 | Int16 | Int32 | Int64 | Int128 | UInt8 | UInt16 | UInt32 | UInt64 | UInt128

  struct TextCombineUprightDigits
    getter count : TextCombineUprightDigitCount?

    def initialize(@count : TextCombineUprightDigitCount? = nil)
    end

    def to_css_value
      count ? "digits #{count}" : "digits"
    end
  end
end
