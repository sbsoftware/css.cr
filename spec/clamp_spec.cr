require "./spec_helper"

class ClampStyle < CSS::Stylesheet
  rule div do
    width clamp(0, 50.percent, 100.px)
  end
end

describe "ClampStyle.to_s" do
  it "should render clamp() function values" do
    expected = <<-CSS
    div {
      width: clamp(0, 50%, 100px);
    }
    CSS

    ClampStyle.to_s.should eq(expected)
  end
end
