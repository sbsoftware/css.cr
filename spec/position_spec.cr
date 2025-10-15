require "./spec_helper"

module CSS::PositionSpec
  class Style < CSS::Stylesheet
    rule div do
      position :absolute
      top 10.px
      inset_block_start 10.px
      bottom 10.px
      inset_block_end 10.px
      left 50.px
      inset_inline_start 50.px
      right 50.px
      inset_inline_end 50.px
      inset 10.px, 50.px, 50.px, 10.px
    end

    rule article do
      position :fixed
      inset_inline 10.px
      inset_block 10.px
      inset 10.px, 10.px, 10.px
    end

    rule aside do
      position :relative
      inset_inline 5.px, 10.px
      inset_block 10.px, 5.px
      inset 10.px, 5.px
    end

    rule header do
      position :sticky
      inset 10.px
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        position: absolute;
        top: 10px;
        inset-block-start: 10px;
        bottom: 10px;
        inset-block-end: 10px;
        left: 50px;
        inset-inline-start: 50px;
        right: 50px;
        inset-inline-end: 50px;
        inset: 10px 50px 50px 10px;
      }

      article {
        position: fixed;
        inset-inline: 10px;
        inset-block: 10px;
        inset: 10px 10px 10px;
      }

      aside {
        position: relative;
        inset-inline: 5px 10px;
        inset-block: 10px 5px;
        inset: 10px 5px;
      }

      header {
        position: sticky;
        inset: 10px;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
