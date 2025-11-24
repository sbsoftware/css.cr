require "./spec_helper"

class FloatStyle < CSS::Stylesheet
  rule div do
    float :none
    float :left
    float :inline_end

    clear :right
    clear :inline_start
    clear :both
  end
end

describe "FloatStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      float: none;
      float: left;
      float: inline-end;
      clear: right;
      clear: inline-start;
      clear: both;
    }
    CSS

    FloatStyle.to_s.should eq(expected)
  end
end
