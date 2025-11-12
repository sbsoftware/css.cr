require "./spec_helper"

class OverflowStyle < CSS::Stylesheet
  rule div do
    hyphens :none
    hyphens :manual

    overflow :visible
    overflow :hidden, :visible

    overflow_anchor :auto
    overflow_anchor :none

    overflow_block :clip

    overflow_clip_margin 1.em
    overflow_clip_margin :content_box, 10.px

    overflow_inline :auto

    overflow_wrap :normal
    overflow_wrap :break_word

    overflow_x :scroll

    overflow_y :hidden

    overscroll_behavior :contain
    overscroll_behavior :none, :auto
    overscroll_behavior_block :contain
    overscroll_behavior_inline :auto
    overscroll_behavior_x :none;
    overscroll_behavior_y :contain
  end
end

describe "OverflowStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      hyphens: none;
      hyphens: manual;
      overflow: visible;
      overflow: hidden visible;
      overflow-anchor: auto;
      overflow-anchor: none;
      overflow-block: clip;
      overflow-clip-margin: 1em;
      overflow-clip-margin: content-box 10px;
      overflow-inline: auto;
      overflow-wrap: normal;
      overflow-wrap: break-word;
      overflow-x: scroll;
      overflow-y: hidden;
      overscroll-behavior: contain;
      overscroll-behavior: none auto;
      overscroll-behavior-block: contain;
      overscroll-behavior-inline: auto;
      overscroll-behavior-x: none;
      overscroll-behavior-y: contain;
    }
    CSS

    OverflowStyle.to_s.should eq(expected)
  end
end
