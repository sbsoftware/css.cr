require "./spec_helper"

module CSS::StylesheetTest
  class SingleRuleStylesheet < CSS::Stylesheet
    rule a do
      display :inline_block
    end
  end

  class MultiRuleStylesheet < CSS::Stylesheet
    rule div do
      display :block
    end

    rule h1 do
      display :none
    end
  end

  describe "A Stylesheet" do
    context "#to_s" do
      context "with a single rule" do
        it "should return valid CSS" do
          expected = <<-CSS
          a {
            display: inline-block;
          }
          CSS

          SingleRuleStylesheet.to_s.should eq(expected)
        end
      end

      context "with multiple rules" do
        it "should return valid CSS" do
          expected = <<-CSS
          div {
            display: block;
          }

          h1 {
            display: none;
          }
          CSS

          MultiRuleStylesheet.to_s.should eq(expected)
        end
      end
    end
  end
end
