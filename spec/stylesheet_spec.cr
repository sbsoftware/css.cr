require "./spec_helper"

module CSS::StylesheetTest
  class SingleRuleStylesheet < CSS::Stylesheet
    rule a do
      display :inline_block
      z_index 3
      font_weight :bold
    end
  end

  class MultiRuleStylesheet < CSS::Stylesheet
    rule div do
      display :block
      opacity 7
      font_weight 400
    end

    rule h1 do
      display :none
      opacity 63.4
    end
  end

  describe "A Stylesheet" do
    context "#to_s" do
      context "with a single rule" do
        it "should return valid CSS" do
          expected = <<-CSS
          a {
            display: inline-block;
            z-index: 3;
            font-weight: bold;
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
            opacity: 7;
            font-weight: 400;
          }

          h1 {
            display: none;
            opacity: 63.4;
          }
          CSS

          MultiRuleStylesheet.to_s.should eq(expected)
        end
      end
    end
  end
end
