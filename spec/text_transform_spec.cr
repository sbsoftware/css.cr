require "./spec_helper"

module CSS::TextTransformSpec
  class Style < CSS::Stylesheet
    rule h1 do
      text_transform :none
      text_transform :math_auto
      text_transform :uppercase
      text_transform :full_width
      text_transform :full_size_kana
      text_transform :lowercase, :full_width
      text_transform :capitalize, :full_width, :full_size_kana
    end
  end

  describe "Style.to_s" do
    it "renders keyword and combination values" do
      expected = <<-CSS
      h1 {
        text-transform: none;
        text-transform: math-auto;
        text-transform: uppercase;
        text-transform: full-width;
        text-transform: full-size-kana;
        text-transform: lowercase full-width;
        text-transform: capitalize full-width full-size-kana;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
