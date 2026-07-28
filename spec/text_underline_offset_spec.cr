require "./spec_helper"

module CSS::TextUnderlineOffsetSpec
  class Style < CSS::Stylesheet
    rule a do
      text_underline_offset 0.12.em
      text_underline_offset 12.percent
      text_underline_offset "auto"
    end
  end

  describe "Style.to_s" do
    it "renders typed length and string text underline offsets" do
      expected = <<-CSS
      a {
        text-underline-offset: 0.12em;
        text-underline-offset: 12%;
        text-underline-offset: "auto";
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
