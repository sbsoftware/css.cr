require "./spec_helper"

module CSS::TextOverflowSpec
  class Style < CSS::Stylesheet
    rule p do
      text_overflow :ellipsis
    end

    rule div do
      text_overflow ">>>"
    end

    rule section do
      text_overflow :clip, :ellipsis
    end

    rule article do
      text_overflow ">>", :clip
    end
  end

  describe "Style.to_s" do
    it "renders keyword and custom string values" do
      expected = <<-CSS
      p {
        text-overflow: ellipsis;
      }

      div {
        text-overflow: ">>>";
      }

      section {
        text-overflow: clip ellipsis;
      }

      article {
        text-overflow: ">>" clip;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
