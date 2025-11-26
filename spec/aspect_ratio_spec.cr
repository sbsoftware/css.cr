require "./spec_helper"

module CSS::AspectRatioSpec
  class Style < CSS::Stylesheet
    rule div do
      aspect_ratio ratio(16, 9)
    end

    rule img do
      aspect_ratio 1.5
    end

    rule video do
      aspect_ratio :auto
    end

    rule section do
      aspect_ratio 3.0 / 2
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        aspect-ratio: 16 / 9;
      }

      img {
        aspect-ratio: 1.5;
      }

      video {
        aspect-ratio: auto;
      }

      section {
        aspect-ratio: 1.5;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
