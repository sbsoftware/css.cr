require "./spec_helper"

module CSS::WordWrapSpec
  class Style < CSS::Stylesheet
    rule p do
      word_wrap :normal
    end

    rule span do
      word_wrap :break_word
    end

    rule div do
      word_wrap :anywhere
    end
  end

  describe "Style.to_s" do
    it "renders supported word-wrap values" do
      expected = <<-CSS
      p {
        word-wrap: normal;
      }

      span {
        word-wrap: break-word;
      }

      div {
        word-wrap: anywhere;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
