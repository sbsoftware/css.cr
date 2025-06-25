require "./spec_helper"

module CSS::SelectorSpec
  css_class Test

  class Style < CSS::Stylesheet
    rule any do
      display :block
    end

    rule div do
      display :flex
    end

    rule Test do
      display :none
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

      .css--selector-spec--test {
        display: none;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
