require "./spec_helper"

class DirectionStyle < CSS::Stylesheet
  rule div do
    direction :ltr
    direction :rtl
  end
end

describe "DirectionStyle.to_s" do
  it "serializes typed direction values" do
    DirectionStyle.to_s.should eq(<<-CSS)
    div {
      direction: ltr;
      direction: rtl;
    }
    CSS
  end
end
