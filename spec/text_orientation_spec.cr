require "./spec_helper"

class TextOrientationStyle < CSS::Stylesheet
  rule div do
    text_orientation :mixed
    text_orientation :upright
    text_orientation :sideways
  end
end

describe "TextOrientationStyle.to_s" do
  it "serializes typed text-orientation values" do
    TextOrientationStyle.to_s.should eq(<<-CSS)
    div {
      text-orientation: mixed;
      text-orientation: upright;
      text-orientation: sideways;
    }
    CSS
  end
end
