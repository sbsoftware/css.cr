require "./spec_helper"

module CSS::NamedColorSpec
  class Style < CSS::Stylesheet
    rule div do
      background_color :orange
      border_color :lightgreen;
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        background-color: orange;
        border-color: lightgreen;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
