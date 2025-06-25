require "./spec_helper"

module CSS::SelectorSpec
  class Style < CSS::Stylesheet
    rule any do
      display :block
    end

    rule div do
      display :flex
    end
  end

  describe "Style.to_s" do
    it "returns the correct CSS" do
      expected = <<-CSS
      * {
        display: block;
      }

      div {
        display: flex;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
