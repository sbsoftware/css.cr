require "./spec_helper"

module CSS::BackdropFilterSpec
  class Style < CSS::Stylesheet
    rule ".panel" do
      backdrop_filter blur(12.px)
      backdrop_filter brightness(80.percent)
      backdrop_filter contrast(1.2)
      backdrop_filter drop_shadow(0.px, 4.px, 12.px, :black)
      backdrop_filter grayscale(50.percent)
      backdrop_filter hue_rotate(90.deg)
      backdrop_filter invert(25.percent)
      backdrop_filter opacity(75.percent)
      backdrop_filter saturate(1.4)
      backdrop_filter sepia(30.percent)
      backdrop_filter blur(8.px), brightness(115.percent), contrast(90.percent)
      backdrop_filter :none
    end
  end

  describe "Style.to_s" do
    it "renders backdrop-filter functions" do
      expected = <<-CSS
      .panel {
        backdrop-filter: blur(12px);
        backdrop-filter: brightness(80%);
        backdrop-filter: contrast(1.2);
        backdrop-filter: drop-shadow(0px 4px 12px black);
        backdrop-filter: grayscale(50%);
        backdrop-filter: hue-rotate(90deg);
        backdrop-filter: invert(25%);
        backdrop-filter: opacity(75%);
        backdrop-filter: saturate(1.4);
        backdrop-filter: sepia(30%);
        backdrop-filter: blur(8px) brightness(115%) contrast(90%);
        backdrop-filter: none;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
