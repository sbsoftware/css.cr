require "./spec_helper"

module CSS::FlexSpec
  class Style < CSS::Stylesheet
    rule div do
      display :flex
      flex_direction :row_reverse
      flex_wrap :wrap_reverse
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        display: flex;
        flex-direction: row-reverse;
        flex-wrap: wrap-reverse;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
