module CSS::Enums
  enum PointerEvents
    Auto
    BoundingBox
    VisiblePainted
    VisibleFill
    VisibleStroke
    Visible
    Painted
    Fill
    Stroke
    All
    None

    def to_css_value
      case self
      when BoundingBox
        "bounding-box"
      when VisiblePainted
        "visiblePainted"
      when VisibleFill
        "visibleFill"
      when VisibleStroke
        "visibleStroke"
      else
        to_s.downcase
      end
    end
  end
end
