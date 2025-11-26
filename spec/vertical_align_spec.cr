require "./spec_helper"

module CSS::VerticalAlignSpec
  class Style < CSS::Stylesheet
    rule span do
      vertical_align :baseline
    end

    rule sup do
      vertical_align :super
    end

    rule small do
      vertical_align :text_bottom
    end

    rule img do
      vertical_align 4.px
    end

    rule strong do
      vertical_align 20.percent
    end
  end

  describe "Style.to_s" do
    it "renders keyword, length and percentage values" do
      expected = <<-CSS
      span {
        vertical-align: baseline;
      }

      sup {
        vertical-align: super;
      }

      small {
        vertical-align: text-bottom;
      }

      img {
        vertical-align: 4px;
      }

      strong {
        vertical-align: 20%;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
