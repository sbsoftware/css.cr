module CSS
  struct AnchorName
    getter value : String

    def initialize(value : Symbol)
      @value = "--#{value.to_s.gsub('_', '-')}"
    end

    def initialize(value : String)
      @value = value.starts_with?("--") ? value : "--#{value}"
    end

    def initialize(value : AnchorName)
      @value = value.value
    end

    def to_s(io : IO)
      io << value
    end

    def to_css_value
      to_s
    end
  end
end
