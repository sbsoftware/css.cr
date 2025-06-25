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

    rule input && "[data-test]" do
      display :none
    end

    rule "select" && CSS::AttrSelector.new("data-test") do
      display :none
    end

    rule div && CSS::AttrSelector.new("data-test", "blah") do
      display :none
    end

    rule div <= :before do
      display :flex
    end

    rule div <= CSS::NthOfType.new(3) do
      display :none
    end

    rule div <= CSS::NthOfType.new(:odd) do
      display :none
    end

    rule div <= CSS::NthOfType.new("2n+2") do
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

      input[data-test] {
        display: none;
      }

      select[data-test] {
        display: none;
      }

      div[data-test="blah"] {
        display: none;
      }

      div:before {
        display: flex;
      }

      div:nth-of-type(3) {
        display: none;
      }

      div:nth-of-type(odd) {
        display: none;
      }

      div:nth-of-type(2n+2) {
        display: none;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
