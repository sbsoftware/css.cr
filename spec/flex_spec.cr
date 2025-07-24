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
      flex_grow :inherit
      flex_shrink :unset
      flex_basis :auto
      flex 0
      align_self :stretch
      order :inherit
      gap 2.cm

      rule div do
        display :inherit
        flex_direction :unset
        flex_wrap :revert
        flex_flow :column_reverse, :nowrap
        justify_content :unsafe, :right
        align_items :first, :baseline
        align_content :unsafe, :flex_end
        flex_grow 2
        flex_shrink 0.7
        flex_basis :min_content
        flex :content
        align_self :self_end
        order 5
        gap 20.percent
      end
    end

    rule header do
      align_items :safe, :anchor_center
      align_content :baseline
      flex_grow 0.6
      flex_shrink 1
      flex_basis 200.px
      flex 1, 1
      align_self :unsafe, :center
      order -1
      gap 3.vmax, 3.vmin

      rule div do
        flex 2, 0, 75.px
        align_self :last, :baseline
        order 0
        gap 3.px, 10.percent
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
        justify-content: space-between;
        align-items: normal;
        align-content: stretch;
        flex-grow: inherit;
        flex-shrink: unset;
        flex-basis: auto;
        flex: 0;
        align-self: stretch;
        order: inherit;
        gap: 2cm;
      }

      div div {
        display: inherit;
        flex-direction: unset;
        flex-wrap: revert;
        flex-flow: column-reverse nowrap;
        justify-content: unsafe right;
        align-items: first baseline;
        align-content: unsafe flex-end;
        flex-grow: 2;
        flex-shrink: 0.7;
        flex-basis: min-content;
        flex: content;
        align-self: self-end;
        order: 5;
        gap: 20%;
      }

      header {
        align-items: safe anchor-center;
        align-content: baseline;
        flex-grow: 0.6;
        flex-shrink: 1;
        flex-basis: 200px;
        flex: 1 1;
        align-self: unsafe center;
        order: -1;
        gap: 3vmax 3vmin;
      }

      header div {
        flex: 2 0 75px;
        align-self: last baseline;
        order: 0;
        gap: 3px 10%;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
