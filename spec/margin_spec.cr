require "./spec_helper"

module CSS::MarginSpec
  class Style < CSS::Stylesheet
    rule div do
      margin 0
      margin_block 0, 0
      margin_block_end 0
      margin_block_start 0
      margin_bottom 0
      margin_inline 0, 0
      margin_inline_end 0
      margin_inline_start 0
      margin_left 0
      margin_right 0
      margin_top 0
    end

    rule h1 do
      margin :inherit
      margin_block :unset
      margin_block_end :revert
      margin_block_start :revert_layer
      margin_bottom :initial
      margin_inline :inherit
    end

    rule section do
      margin 5.px, 0
      margin_block 3.px
      margin_block_end 5.px
      margin_block_start 5.px
      margin_bottom 5.px
      margin_inline 1.px
      margin_inline_end 1.px
      margin_inline_start 1.px
      margin_left 1.px
      margin_right 1.px
      margin_top 1.px
    end

    rule aside do
      margin 3.px, 5.px, 10.percent
      margin_block 2.em, 2.em
      margin_inline 2.vh, 2.vw
    end

    rule p do
      margin 0, 2.em, 5.percent, 3.px
    end
  end
end
