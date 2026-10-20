module CSS
  struct TextCombineUprightDigits
    getter count : Int::Primitive?

    def initialize(@count : Int::Primitive? = nil)
    end

    def to_css_value
      count ? "digits #{count}" : "digits"
    end
  end
end
