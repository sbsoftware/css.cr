require "./spec_helper"

module CSS::WhiteSpaceSpec
  class Style < CSS::Stylesheet
    rule p do
      white_space :normal
    end

    rule pre do
      white_space :pre
    end

    rule span do
      white_space :nowrap
    end

    rule section do
      white_space :pre_wrap
    end

    rule article do
      white_space :pre_line
    end

    rule div do
      white_space :break_spaces
    end
  end

  describe "Style.to_s" do
    it "renders supported white-space values" do
      expected = <<-CSS
      p {
        white-space: normal;
      }

      pre {
        white-space: pre;
      }

      span {
        white-space: nowrap;
      }

      section {
        white-space: pre-wrap;
      }

      article {
        white-space: pre-line;
      }

      div {
        white-space: break-spaces;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
