require "./spec_helper"

class TextShadowStyle < CSS::Stylesheet
  rule h1 do
    text_shadow :none
    text_shadow :red, 1.px, 2.px
    text_shadow "#112233", 0, 0, 4.px
    text_shadow rgb(0, 0, 0, alpha: 50.percent), 0.1.em, 0.2.em, 0.3.em
  end
end

describe "TextShadowStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    h1 {
      text-shadow: none;
      text-shadow: red 1px 2px;
      text-shadow: #112233 0 0 4px;
      text-shadow: rgb(0, 0, 0, 50%) 0.1em 0.2em 0.3em;
    }
    CSS

    TextShadowStyle.to_s.should eq(expected)
  end
end
