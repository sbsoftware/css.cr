require "./spec_helper"

module CSS::SizeSpec
  class Style < CSS::Stylesheet
    rule div do
      width 100.percent
      height 100.percent
      block_size 100.percent
      inline_size 100.percent
      min_width :stretch
      min_height :max_content
      min_block_size :fit_content
      min_inline_size :min_content
      max_width 1000.px
      max_height 100.vh
      max_block_size 100.em
      max_inline_size 1075.ex
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        width: 100%;
        height: 100%;
        block-size: 100%;
        inline-size: 100%;
        min-width: stretch;
        min-height: max-content;
        min-block-size: fit-content;
        min-inline-size: min-content;
        max-width: 1000px;
        max-height: 100vh;
        max-block-size: 100em;
        max-inline-size: 1075ex;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
