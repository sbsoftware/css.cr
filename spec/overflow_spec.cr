require "./spec_helper"

class OverflowStyle < CSS::Stylesheet
  rule div do
    overscroll_behavior :contain
    overscroll_behavior :none, :auto
    overscroll_behavior_block :contain
    overscroll_behavior_inline :auto
    overscroll_behavior_x :none;
    overscroll_behavior_y :contain
  end
end

describe "OverflowStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      overscroll-behavior: contain;
      overscroll-behavior: none auto;
      overscroll-behavior-block: contain;
      overscroll-behavior-inline: auto;
      overscroll-behavior-x: none;
      overscroll-behavior-y: contain;
    }
    CSS

    OverflowStyle.to_s.should eq(expected)
  end
end
