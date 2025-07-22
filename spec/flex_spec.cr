require "./spec_helper"

module CSS::FlexSpec
  class Style < CSS::Stylesheet
    rule div do
      display :flex
      flex_direction :row_reverse
      flex_wrap :wrap_reverse
      flex_flow :row

      rule div do
        display :inherit
        flex_direction :unset
        flex_wrap :revert
        flex_flow :column_reverse, :nowrap
      end
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        display: flex;
        flex-direction: row-reverse;
        flex-wrap: wrap-reverse;
        flex-flow: row;
      }

      div div {
        display: inherit;
        flex-direction: unset;
        flex-wrap: revert;
        flex-flow: column-reverse nowrap;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
