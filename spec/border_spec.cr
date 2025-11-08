require "./spec_helper"

class BorderStyle < CSS::Stylesheet
  rule div do
    border_image url("/images/border.png"), 27
    border_image url("/images/border.png"), 27, :space

    border_image_outset 1.rem
    border_image_outset 1.5
    border_image_outset 1, 1.2
    border_image_outset 30.px, 2, 45.px
    border_image_outset 7.px, 12.px, 14.px, 5.px

    border_image_repeat :stretch
    border_image_repeat :repeat
    border_image_repeat :round
    border_image_repeat :space
    border_image_repeat :round, :stretch

    border_image_slice 30.percent
    border_image_slice 10.percent, 30.percent
    border_image_slice 30, 30.percent, 45
    border_image_slice 7, 12, 14, 5
    border_image_slice :fill, 10.percent
    border_image_slice 10.percent, 30, 45, 20.percent, :fill

    border_image_source url("/shared/image.jpg")

    border_image_width :auto
    border_image_width 1.rem
    border_image_width 25.percent
    border_image_width 3
    border_image_width 2.em, 3.em
    border_image_width 5.percent, 10.percent, 15.percent
    border_image_width 5.percent, 2.em, 10.percent, :auto

    border :solid
    border 2.px, :dotted
    border :outset, "#ff3333"
    border :medium, :dashed, :green

    border_block 1.px
    border_block 2.px, :dotted
    border_block :medium, :dashed, :green

    border_block_color :red
    border_block_color :blue, "#FFF"

    border_block_end 1.px
    border_block_end 2.px, :dotted
    border_block_end :medium, :dashed, :green

    border_block_end_color :current_color
    border_block_end_color :pink
    border_block_end_color "#ff0000"
    border_block_end_color rgb(255, 255, 255, alpha: 1)

    border_block_end_style :none
    border_block_end_style :groove

    border_block_end_width :thick
    border_block_end_width 2.px

    border_block_start 1.px
    border_block_start 2.px, :dotted
    border_block_start :medium, :dashed, :green

    border_block_start_color :current_color
    border_block_start_color :pink
    border_block_start_color "#ff0000"
    border_block_start_color rgb(255, 255, 255, alpha: 1)

    border_block_start_style :none
    border_block_start_style :groove

    border_block_start_width :thick
    border_block_start_width 2.px

    border_block_style :solid, :dotted
    border_block_style :dashed

    border_block_width 5.px, 10.px
    border_block_width 5.px
    border_block_width :thick

    border_bottom 1.px
    border_bottom 2.px, :dotted
    border_bottom :medium, :dashed, :green

    border_bottom_color :current_color
    border_bottom_color :pink
    border_bottom_color "#ff0000"
    border_bottom_color rgb(255, 255, 255, alpha: 1)

    border_bottom_left_radius 3.px
    border_bottom_left_radius 1.5.em, 2.em

    border_bottom_right_radius 3.px
    border_bottom_right_radius 1.5.em, 2.em

    border_bottom_style :none
    border_bottom_style :groove

    border_bottom_width 2.em
    border_bottom_width 0
    border_bottom_width :thick

    border_collapse :collapse
    border_collapse :separate

    border_color :red
    border_color :red, "#f015ca"
    border_color :red, rgb(240, 30, 50, alpha: 70.percent), :green
    border_color :red, :yellow, :green, :blue

    border_end_end_radius 10.px
    border_end_end_radius 1.em, 2.em

    border_end_start_radius 10.px
    border_end_start_radius 1.em, 2.em

    border_inline 1.px
    border_inline 2.px, :dotted
    border_inline :medium, :dashed, :green

    border_inline_color :red
    border_inline_color :blue, "#FFF"

    border_inline_end 1.px
    border_inline_end 2.px, :dotted
    border_inline_end :medium, :dashed, :green

    border_inline_end_color :current_color
    border_inline_end_color :pink
    border_inline_end_color "#ff0000"
    border_inline_end_color rgb(255, 255, 255, alpha: 1)

    border_inline_end_style :none
    border_inline_end_style :groove

    border_inline_end_width :thick
    border_inline_end_width 2.px

    border_inline_start 1.px
    border_inline_start 2.px, :dotted
    border_inline_start :medium, :dashed, :green

    border_inline_start_color :current_color
    border_inline_start_color :pink
    border_inline_start_color "#ff0000"
    border_inline_start_color rgb(255, 255, 255, alpha: 1)

    border_inline_start_style :none
    border_inline_start_style :groove

    border_inline_start_width :thick
    border_inline_start_width 2.px

    border_inline_style :solid, :dotted
    border_inline_style :dashed

    border_inline_width 5.px, 10.px
    border_inline_width 5.px
    border_inline_width :thick

    border_left 1.px
    border_left 2.px, :dotted
    border_left :medium, :dashed, :green

    border_left_color :current_color
    border_left_color :pink
    border_left_color "#ff0000"
    border_left_color rgb(255, 255, 255, alpha: 1)

    border_left_style :none
    border_left_style :groove

    border_left_width :thick
    border_left_width 2.px

    border_radius 10.px
    border_radius 10.px, 5.percent
    border_radius 2.px, 4.px, 2.px
    border_radius 1.px, 0, 3.px, 4.px

    border_right 1.px
    border_right 2.px, :dotted
    border_right :medium, :dashed, :green

    border_right_color :current_color
    border_right_color :pink
    border_right_color "#ff0000"
    border_right_color rgb(255, 255, 255, alpha: 1)

    border_right_style :none
    border_right_style :groove

    border_right_width :thick
    border_right_width 2.px

    border_spacing 1.px
    border_spacing 1.cm, 1.em

    border_start_end_radius 10.px
    border_start_end_radius 1.em, 2.em

    border_start_start_radius 10.px
    border_start_start_radius 1.em, 2.em

    border_style :none
    border_style :dotted, :solid
    border_style :hidden, :double, :dashed
    border_style :none, :solid, :dotted, :dashed

    border_top 1.px
    border_top 2.px, :dotted
    border_top :medium, :dashed, :green

    border_top_color :current_color
    border_top_color :pink
    border_top_color "#ff0000"
    border_top_color rgb(255, 255, 255, alpha: 1)

    border_top_left_radius 3.px
    border_top_left_radius 1.5.em, 2.em

    border_top_right_radius 3.px
    border_top_right_radius 1.5.em, 2.em

    border_top_style :none
    border_top_style :groove

    border_top_width 2.em
    border_top_width 0
    border_top_width :thick

    border_width :thin
    border_width 2.px, 1.5.em
    border_width 1.px, 2.em, 1.5.cm
    border_width 1.px, 2.em, 0, 4.rem
  end
end

describe "Style.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      border-image: url("/images/border.png") 27;
      border-image: url("/images/border.png") 27 space;
      border-image-outset: 1rem;
      border-image-outset: 1.5;
      border-image-outset: 1 1.2;
      border-image-outset: 30px 2 45px;
      border-image-outset: 7px 12px 14px 5px;
      border-image-repeat: stretch;
      border-image-repeat: repeat;
      border-image-repeat: round;
      border-image-repeat: space;
      border-image-repeat: round stretch;
      border-image-slice: 30%;
      border-image-slice: 10% 30%;
      border-image-slice: 30 30% 45;
      border-image-slice: 7 12 14 5;
      border-image-slice: fill 10%;
      border-image-slice: 10% 30 45 20% fill;
      border-image-source: url("/shared/image.jpg");
      border-image-width: auto;
      border-image-width: 1rem;
      border-image-width: 25%;
      border-image-width: 3;
      border-image-width: 2em 3em;
      border-image-width: 5% 10% 15%;
      border-image-width: 5% 2em 10% auto;
      border: solid;
      border: 2px dotted;
      border: outset #ff3333;
      border: medium dashed green;
      border-block: 1px;
      border-block: 2px dotted;
      border-block: medium dashed green;
      border-block-color: red;
      border-block-color: blue #FFF;
      border-block-end: 1px;
      border-block-end: 2px dotted;
      border-block-end: medium dashed green;
      border-block-end-color: currentColor;
      border-block-end-color: pink;
      border-block-end-color: #ff0000;
      border-block-end-color: rgb(255, 255, 255, 1);
      border-block-end-style: none;
      border-block-end-style: groove;
      border-block-end-width: thick;
      border-block-end-width: 2px;
      border-block-start: 1px;
      border-block-start: 2px dotted;
      border-block-start: medium dashed green;
      border-block-start-color: currentColor;
      border-block-start-color: pink;
      border-block-start-color: #ff0000;
      border-block-start-color: rgb(255, 255, 255, 1);
      border-block-start-style: none;
      border-block-start-style: groove;
      border-block-start-width: thick;
      border-block-start-width: 2px;
      border-block-style: solid dotted;
      border-block-style: dashed;
      border-block-width: 5px 10px;
      border-block-width: 5px;
      border-block-width: thick;
      border-bottom: 1px;
      border-bottom: 2px dotted;
      border-bottom: medium dashed green;
      border-bottom-color: currentColor;
      border-bottom-color: pink;
      border-bottom-color: #ff0000;
      border-bottom-color: rgb(255, 255, 255, 1);
      border-bottom-left-radius: 3px;
      border-bottom-left-radius: 1.5em 2em;
      border-bottom-right-radius: 3px;
      border-bottom-right-radius: 1.5em 2em;
      border-bottom-style: none;
      border-bottom-style: groove;
      border-bottom-width: 2em;
      border-bottom-width: 0;
      border-bottom-width: thick;
      border-collapse: collapse;
      border-collapse: separate;
      border-color: red;
      border-color: red #f015ca;
      border-color: red rgb(240, 30, 50, 70%) green;
      border-color: red yellow green blue;
      border-end-end-radius: 10px;
      border-end-end-radius: 1em 2em;
      border-end-start-radius: 10px;
      border-end-start-radius: 1em 2em;
      border-inline: 1px;
      border-inline: 2px dotted;
      border-inline: medium dashed green;
      border-inline-color: red;
      border-inline-color: blue #FFF;
      border-inline-end: 1px;
      border-inline-end: 2px dotted;
      border-inline-end: medium dashed green;
      border-inline-end-color: currentColor;
      border-inline-end-color: pink;
      border-inline-end-color: #ff0000;
      border-inline-end-color: rgb(255, 255, 255, 1);
      border-inline-end-style: none;
      border-inline-end-style: groove;
      border-inline-end-width: thick;
      border-inline-end-width: 2px;
      border-inline-start: 1px;
      border-inline-start: 2px dotted;
      border-inline-start: medium dashed green;
      border-inline-start-color: currentColor;
      border-inline-start-color: pink;
      border-inline-start-color: #ff0000;
      border-inline-start-color: rgb(255, 255, 255, 1);
      border-inline-start-style: none;
      border-inline-start-style: groove;
      border-inline-start-width: thick;
      border-inline-start-width: 2px;
      border-inline-style: solid dotted;
      border-inline-style: dashed;
      border-inline-width: 5px 10px;
      border-inline-width: 5px;
      border-inline-width: thick;
      border-left: 1px;
      border-left: 2px dotted;
      border-left: medium dashed green;
      border-left-color: currentColor;
      border-left-color: pink;
      border-left-color: #ff0000;
      border-left-color: rgb(255, 255, 255, 1);
      border-left-style: none;
      border-left-style: groove;
      border-left-width: thick;
      border-left-width: 2px;
      border-radius: 10px;
      border-radius: 10px 5%;
      border-radius: 2px 4px 2px;
      border-radius: 1px 0 3px 4px;
      border-right: 1px;
      border-right: 2px dotted;
      border-right: medium dashed green;
      border-right-color: currentColor;
      border-right-color: pink;
      border-right-color: #ff0000;
      border-right-color: rgb(255, 255, 255, 1);
      border-right-style: none;
      border-right-style: groove;
      border-right-width: thick;
      border-right-width: 2px;
      border-spacing: 1px;
      border-spacing: 1cm 1em;
      border-start-end-radius: 10px;
      border-start-end-radius: 1em 2em;
      border-start-start-radius: 10px;
      border-start-start-radius: 1em 2em;
      border-style: none;
      border-style: dotted solid;
      border-style: hidden double dashed;
      border-style: none solid dotted dashed;
      border-top: 1px;
      border-top: 2px dotted;
      border-top: medium dashed green;
      border-top-color: currentColor;
      border-top-color: pink;
      border-top-color: #ff0000;
      border-top-color: rgb(255, 255, 255, 1);
      border-top-left-radius: 3px;
      border-top-left-radius: 1.5em 2em;
      border-top-right-radius: 3px;
      border-top-right-radius: 1.5em 2em;
      border-top-style: none;
      border-top-style: groove;
      border-top-width: 2em;
      border-top-width: 0;
      border-top-width: thick;
      border-width: thin;
      border-width: 2px 1.5em;
      border-width: 1px 2em 1.5cm;
      border-width: 1px 2em 0 4rem;
    }
    CSS

    BorderStyle.to_s.should eq(expected)
  end
end
