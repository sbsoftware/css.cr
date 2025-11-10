require "./spec_helper"

class BoxShadowStyle < CSS::Stylesheet
  rule div do
    box_shadow :none
    box_shadow :red, 60.px, -16.px
    box_shadow 10.px, 5.px, 5.px, :black
    box_shadow 2.px, 2.px, 2.px, 1.px, rgb(0, 0, 0, alpha: 20.percent)
    box_shadow :inset, 1.em, 2.em, :gold
    box_shadow :green, 2.px, 2.px, 2.px, 1.px, :inset
  end
end

describe "BoxShadowStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      box-shadow: none;
      box-shadow: red 60px -16px;
      box-shadow: 10px 5px 5px black;
      box-shadow: 2px 2px 2px 1px rgb(0, 0, 0, 20%);
      box-shadow: inset 1em 2em gold;
      box-shadow: green 2px 2px 2px 1px inset;
    }
    CSS

    BoxShadowStyle.to_s.should eq(expected)
  end
end
