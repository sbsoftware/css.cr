module CSS
  # Represents a `from <angle>` clause for conic-gradient().
  struct ConicGradientFrom
    getter angle : String

    def initialize(angle)
      @angle = angle.to_css_value.to_s
    end

    def to_css_value
      "from #{angle}"
    end
  end
end
