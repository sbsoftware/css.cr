require "./spec_helper"

class TextCombineUprightStyle < CSS::Stylesheet
  rule div do
    text_combine_upright :none
    text_combine_upright :all
    text_combine_upright :digits
    text_combine_upright digits(3)
  end
end

describe "TextCombineUprightStyle.to_s" do
  it "serializes typed keyword and digits values" do
    TextCombineUprightStyle.to_s.should eq(<<-CSS)
    div {
      text-combine-upright: none;
      text-combine-upright: all;
      text-combine-upright: digits;
      text-combine-upright: digits 3;
    }
    CSS
  end
end
