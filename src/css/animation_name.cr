module CSS
  struct AnimationName
    getter value : String

    def initialize(@value); end

    def to_s(io : IO)
      io << value
    end

    def to_css_value
      to_s
    end
  end
end
