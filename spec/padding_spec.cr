require "./spec_helper"

module CSS::PaddingSpec
  class Style < CSS::Stylesheet
    rule div do
      padding 0
      padding_block 0, 0
      padding_block_end 0
      padding_block_start 0
      padding_bottom 0
      padding_inline 0, 0
      padding_inline_end 0
      padding_inline_start 0
      padding_left 0
      padding_right 0
      padding_top 0
    end

    rule h1 do
      padding :inherit
      padding_block :unset
      padding_block_end :revert
      padding_block_start :revert_layer
      padding_bottom :initial
      padding_inline :inherit
    end

    rule section do
      padding 5.px, 0
      padding_block 3.px
      padding_block_end 5.px
      padding_block_start 5.px
      padding_bottom 5.px
      padding_inline 1.px
      padding_inline_end 1.px
      padding_inline_start 1.px
      padding_left 1.px
      padding_right 1.px
      padding_top 1.px
    end

    rule aside do
      padding 3.px, 5.px, 10.percent
      padding_block 2.em, 2.em
      padding_inline 2.vh, 2.vw
    end

    rule p do
      padding 0, 2.em, 5.percent, 3.px
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        padding: 0;
        padding-block: 0 0;
        padding-block-end: 0;
        padding-block-start: 0;
        padding-bottom: 0;
        padding-inline: 0 0;
        padding-inline-end: 0;
        padding-inline-start: 0;
        padding-left: 0;
        padding-right: 0;
        padding-top: 0;
      }

      h1 {
        padding: inherit;
        padding-block: unset;
        padding-block-end: revert;
        padding-block-start: revert-layer;
        padding-bottom: initial;
        padding-inline: inherit;
      }

      section {
        padding: 5px 0;
        padding-block: 3px;
        padding-block-end: 5px;
        padding-block-start: 5px;
        padding-bottom: 5px;
        padding-inline: 1px;
        padding-inline-end: 1px;
        padding-inline-start: 1px;
        padding-left: 1px;
        padding-right: 1px;
        padding-top: 1px;
      }

      aside {
        padding: 3px 5px 10%;
        padding-block: 2em 2em;
        padding-inline: 2vh 2vw;
      }

      p {
        padding: 0 2em 5% 3px;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
