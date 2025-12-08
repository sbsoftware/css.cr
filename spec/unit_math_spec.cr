require "./spec_helper"

class ArithmeticStyle < CSS::Stylesheet
  rule div do
    margin_left 8.px * -1
    padding_top -1 * 2.cm
    width 50.percent / 2
  end
end

describe "Unit arithmetic" do
  it "renders valid CSS after arithmetic on units" do
    expected = <<-CSS
    div {
      margin-left: -8px;
      padding-top: -2cm;
      width: 25.0%;
    }
    CSS

    ArithmeticStyle.to_s.should eq(expected)
  end
end
