require "./spec_helper"

class CursorStyle < CSS::Stylesheet
  rule div do
    cursor :auto
    cursor :default
    cursor :zoom_out
  end
end

describe "CursorStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      cursor: auto;
      cursor: default;
      cursor: zoom-out;
    }
    CSS

    CursorStyle.to_s.should eq(expected)
  end
end
