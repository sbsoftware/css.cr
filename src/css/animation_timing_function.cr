module CSS
  struct CubicBezierFunctionCall
    getter x1 : Float64
    getter y1 : Float64
    getter x2 : Float64
    getter y2 : Float64

    def initialize(@x1, @y1, @x2, @y2); end

    def to_s(io : IO)
      io << "cubic-bezier("
      io << x1
      io << ", "
      io << y1
      io << ", "
      io << x2
      io << ", "
      io << y2
      io << ")"
    end

    def to_css_value
      to_s
    end
  end

  struct StepsFunctionCall
    getter count : Int32
    getter position : CSS::Enums::StepPosition?

    def initialize(@count, @position = nil); end

    def to_s(io : IO)
      io << "steps("
      io << count
      if (value = position)
        io << ", "
        io << value.to_css_value
      end
      io << ")"
    end

    def to_css_value
      to_s
    end
  end
end
