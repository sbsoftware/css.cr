require "./spec_helper"

module CSS::SelectorSpec
  css_class Test
  css_id Banner

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

    rule Banner do
      display :grid
    end

    rule div > Banner do
      display :inline
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
      content "Aloha!"
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

  class MultiSelectorStyle < CSS::Stylesheet
    rule div, p do
      display :flex

      rule span do
        display :block
      end

      rule strong, em do
        font_weight :bold
      end
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

      #css--selector-spec--banner {
        display: grid;
      }

      div > #css--selector-spec--banner {
        display: inline;
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
        content: "Aloha!";
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

  describe "MultiSelectorStyle.to_s" do
    it "renders comma-separated selectors and nested rules" do
      expected = <<-CSS
      div, p {
        display: flex;
      }

      div span, p span {
        display: block;
      }

      div strong, div em, p strong, p em {
        font-weight: bold;
      }
      CSS

      MultiSelectorStyle.to_s.should eq(expected)
    end
  end
end
