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

    rule div > Test do
      display :block
    end

    rule any > div > p do
      display :inline_block
    end

    rule body > section > div > h1 do
      display :block
    end

    rule input && Test do
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

      div > .css--selector-spec--test {
        display: block;
      }

      * > div > p {
        display: inline-block;
      }

      body > section > div > h1 {
        display: block;
      }

      input.css--selector-spec--test {
        display: none;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
