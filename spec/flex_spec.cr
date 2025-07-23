require "./spec_helper"

module CSS::FlexSpec
  class Style < CSS::Stylesheet
    rule div do
      display :flex
      flex_direction :row_reverse
      flex_wrap :wrap_reverse
      flex_flow :row
      justify_content :space_between
      align_items :normal
      align_content :stretch

      rule div do
        display :inherit
        flex_direction :unset
        flex_wrap :revert
        flex_flow :column_reverse, :nowrap
        justify_content :unsafe, :right
        align_items :first, :baseline
        align_content :unsafe, :flex_end
      end
    end

    rule header do
      align_items :safe, :anchor_center
      align_content :baseline
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
        justify-content: space-between;
        align-items: normal;
        align-content: stretch;
      }

      div div {
        display: inherit;
        flex-direction: unset;
        flex-wrap: revert;
        flex-flow: column-reverse nowrap;
        justify-content: unsafe right;
        align-items: first baseline;
        align-content: unsafe flex-end;
      }

      header {
        align-items: safe anchor-center;
        align-content: baseline;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
