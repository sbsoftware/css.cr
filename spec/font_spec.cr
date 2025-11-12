require "./spec_helper"

class FontStyle < CSS::Stylesheet
  rule div do
    color :current_color
    color :rebeccapurple
    color "#009900aa"
    color rgb(34, 12, 64)
    color rgb(34, 12, 64, alpha: 0.6)

    font_family "Comic Sans", "Arial", "Times", "Times New Roman", "Georgia", :serif
    font_family "Arial", "Times", "Times New Roman", "Georgia", :serif
    font_family "Times", "Times New Roman", "Georgia", :serif
    font_family "Times", "Georgia", :serif
    font_family "Gill Sans Extrabold", :sans_serif
    font_family :monospace
    font_family :ui_rounded
    font_family :math

    font_kerning :auto
    font_kerning :normal
    font_kerning :none

    font_optical_sizing :none
    font_optical_sizing :auto

    font_size :xx_small
    font_size :medium
    font_size :xxx_large
    font_size :smaller
    font_size 12.px
    font_size 80.percent
    font_size :math

    font_size_adjust :none
    font_size_adjust 0.5
    font_size_adjust :from_font
    font_size_adjust :ex_height, 0.5
    font_size_adjust :ch_width, :from_font

    font_style :normal
    font_style :italic
    font_style :oblique
    font_style :oblique, 10.deg

    font_synthesis :none
    font_synthesis :weight
    font_synthesis :small_caps, :style
    font_synthesis :style, :small_caps, :weight;

    font_synthesis_small_caps :auto
    font_synthesis_small_caps :none

    font_synthesis_style :auto
    font_synthesis_style :none

    font_synthesis_weight :auto
    font_synthesis_weight :none

    font_variant_caps :normal
    font_variant_caps :small_caps
    font_variant_caps :unicase

    font_variation_settings :normal
    font_variation_settings "wght", 625

    font_weight :bold
    font_weight :lighter
    font_weight 600

    line_height :normal
    line_height 2
    line_height 1.5
    line_height 10.px

    text_align :start
    text_align ".", :center

    text_align_last :auto
    text_align_last :end

    text_decoration :none
    text_decoration :overline, :red
    text_decoration :overline, :red, :dotted
    text_decoration :overline, :red, :dotted, 5.px

    text_decoration_color :current_color
    text_decoration_color :red
    text_decoration_color "#00ff00"
    text_decoration_color rgb(255, 128, 128, alpha: 50.percent)
    text_decoration_color :transparent

    text_decoration_line :none
    text_decoration_line :underline
    text_decoration_line :spelling_error
    text_decoration_line :grammar_error
    text_decoration_line :underline, :overline
    text_decoration_line :overline, :underline, :line_through

    text_decoration_skip_ink :none
    text_decoration_skip_ink :auto
    text_decoration_skip_ink :all

    text_decoration_style :wavy

    text_decoration_thickness :auto
    text_decoration_thickness :from_font
    text_decoration_thickness 3.px
    text_decoration_thickness 10.percent
  end
end

describe "FontStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      color: currentColor;
      color: rebeccapurple;
      color: #009900aa;
      color: rgb(34, 12, 64);
      color: rgb(34, 12, 64, 0.6);
      font-family: "Comic Sans", "Arial", "Times", "Times New Roman", "Georgia", serif;
      font-family: "Arial", "Times", "Times New Roman", "Georgia", serif;
      font-family: "Times", "Times New Roman", "Georgia", serif;
      font-family: "Times", "Georgia", serif;
      font-family: "Gill Sans Extrabold", sans-serif;
      font-family: monospace;
      font-family: ui-rounded;
      font-family: math;
      font-kerning: auto;
      font-kerning: normal;
      font-kerning: none;
      font-optical-sizing: none;
      font-optical-sizing: auto;
      font-size: xx-small;
      font-size: medium;
      font-size: xxx-large;
      font-size: smaller;
      font-size: 12px;
      font-size: 80%;
      font-size: math;
      font-size-adjust: none;
      font-size-adjust: 0.5;
      font-size-adjust: from-font;
      font-size-adjust: ex-height 0.5;
      font-size-adjust: ch-width from-font;
      font-style: normal;
      font-style: italic;
      font-style: oblique;
      font-style: oblique 10deg;
      font-synthesis: none;
      font-synthesis: weight;
      font-synthesis: small-caps style;
      font-synthesis: style small-caps weight;
      font-synthesis-small-caps: auto;
      font-synthesis-small-caps: none;
      font-synthesis-style: auto;
      font-synthesis-style: none;
      font-synthesis-weight: auto;
      font-synthesis-weight: none;
      font-variant-caps: normal;
      font-variant-caps: small-caps;
      font-variant-caps: unicase;
      font-variation-settings: normal;
      font-variation-settings: "wght" 625;
      font-weight: bold;
      font-weight: lighter;
      font-weight: 600;
      line-height: normal;
      line-height: 2;
      line-height: 1.5;
      line-height: 10px;
      text-align: start;
      text-align: "." center;
      text-align-last: auto;
      text-align-last: end;
      text-decoration: none;
      text-decoration: overline red;
      text-decoration: overline red dotted;
      text-decoration: overline red dotted 5px;
      text-decoration-color: currentColor;
      text-decoration-color: red;
      text-decoration-color: #00ff00;
      text-decoration-color: rgb(255, 128, 128, 50%);
      text-decoration-color: transparent;
      text-decoration-line: none;
      text-decoration-line: underline;
      text-decoration-line: spelling-error;
      text-decoration-line: grammar-error;
      text-decoration-line: underline overline;
      text-decoration-line: overline underline line-through;
      text-decoration-skip-ink: none;
      text-decoration-skip-ink: auto;
      text-decoration-skip-ink: all;
      text-decoration-style: wavy;
      text-decoration-thickness: auto;
      text-decoration-thickness: from-font;
      text-decoration-thickness: 3px;
      text-decoration-thickness: 10%;
    }
    CSS

    FontStyle.to_s.should eq(expected)
  end
end
