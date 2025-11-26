require "./spec_helper"

module CSS::WebkitTapHighlightColorSpec
  class Style < CSS::Stylesheet
    rule a do
      _webkit_tap_highlight_color :transparent
      _webkit_tap_highlight_color "#123456"
      _webkit_tap_highlight_color rgb(255, 0, 0, alpha: 0.5)
    end
  end

  describe "Style.to_s" do
    it "renders -webkit-tap-highlight-color values" do
      expected = <<-CSS
      a {
        -webkit-tap-highlight-color: transparent;
        -webkit-tap-highlight-color: #123456;
        -webkit-tap-highlight-color: rgb(255, 0, 0, 0.5);
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
