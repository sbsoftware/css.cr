require "./spec_helper"

module NestedRuleSpec
  class Style < CSS::Stylesheet
    rule div do
      display :block

      rule p do
        display :block

        rule span do
          display :inline

          rule strong do
            display :none
          end
        end
      end
    end

    rule h1 do
      display :block
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        display: block;
      }

      div p {
        display: block;
      }

      div p span {
        display: inline;
      }

      div p span strong {
        display: none;
      }

      h1 {
        display: block;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
