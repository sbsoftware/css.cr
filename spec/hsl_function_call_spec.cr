require "./spec_helper"

class HslFunctionCallStyle < CSS::Stylesheet
  rule div do
    color hsl(120, 100.percent, 50.percent)
    background_color hsla(240, 60.percent, 70.percent, 0.5)
    border_color hsl(0, 0.percent, 0.percent), hsla(360, 100.percent, 100.percent, 75.percent)
    box_shadow 0.px, 1.px, 2.px, hsla(30, 80.percent, 40.percent, 1)
    text_decoration_color hsl(210.5, 25.percent, 35.percent)
  end
end

describe "HSL color functions" do
  it "renders hsl and hsla values in color properties" do
    expected = <<-CSS
    div {
      color: hsl(120, 100%, 50%);
      background-color: hsla(240, 60%, 70%, 0.5);
      border-color: hsl(0, 0%, 0%) hsla(360, 100%, 100%, 75%);
      box-shadow: 0px 1px 2px hsla(30, 80%, 40%, 1);
      text-decoration-color: hsl(210.5, 25%, 35%);
    }
    CSS

    HslFunctionCallStyle.to_s.should eq(expected)
  end

  it "validates hsl channels" do
    expect_raises(ArgumentError, "hue must be between 0 and 360") { CSS::HslFunctionCall.new(-1, 100.percent, 50.percent) }
    expect_raises(ArgumentError, "hue must be between 0 and 360") { CSS::HslFunctionCall.new(361, 100.percent, 50.percent) }
    expect_raises(ArgumentError, "saturation must be between 0% and 100%") { CSS::HslFunctionCall.new(120, 101.percent, 50.percent) }
    expect_raises(ArgumentError, "lightness must be between 0% and 100%") { CSS::HslFunctionCall.new(120, 100.percent, -1.percent) }
  end

  it "validates hsla alpha values" do
    expect_raises(ArgumentError, "alpha must be between 0 and 1") { CSS::HslaFunctionCall.new(120, 100.percent, 50.percent, 1.1) }
    expect_raises(ArgumentError, "alpha must be between 0% and 100%") { CSS::HslaFunctionCall.new(120, 100.percent, 50.percent, 101.percent) }
  end
end
