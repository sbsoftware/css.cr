require "./spec_helper"

class CalcStyle < CSS::Stylesheet
  rule div do
    width calc(100.percent - 20.px)
    margin_left calc((10.px + 5.percent) * 2)
  end
end

describe "calc() function" do
  it "renders calculations as valid CSS" do
    expected = <<-CSS
    div {
      width: calc(100% - 20px);
      margin-left: calc((10px + 5%) * 2);
    }
    CSS

    CalcStyle.to_s.should eq(expected)
  end
end
