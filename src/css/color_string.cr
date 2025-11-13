module CSS
  struct ColorString
    @string : String

    def initialize(@string)
    end

    def to_s(io : IO)
      io << @string
    end

    def to_css_value
      to_s
    end
  end
end
