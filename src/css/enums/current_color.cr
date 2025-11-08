module CSS::Enums
  enum CurrentColor
    CurrentColor

    def to_s(io : IO)
      io << "currentColor"
    end
  end
end
