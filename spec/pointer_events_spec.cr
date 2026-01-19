require "./spec_helper"

class PointerEventsStyle < CSS::Stylesheet
  rule svg do
    pointer_events :auto
    pointer_events :none
    pointer_events :visible_painted
    pointer_events :visible_fill
    pointer_events :visible_stroke
    pointer_events :bounding_box
  end
end

describe "PointerEventsStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    svg {
      pointer-events: auto;
      pointer-events: none;
      pointer-events: visiblePainted;
      pointer-events: visibleFill;
      pointer-events: visibleStroke;
      pointer-events: bounding-box;
    }
    CSS

    PointerEventsStyle.to_s.should eq(expected)
  end
end
