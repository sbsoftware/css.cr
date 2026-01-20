require "./spec_helper"

module CSS::UserSelectSpec
  class Style < CSS::Stylesheet
    rule p do
      user_select :auto
    end

    rule span do
      user_select :text
    end

    rule div do
      user_select :none
    end

    rule section do
      user_select :contain
    end

    rule article do
      user_select :all
    end
  end

  describe "Style.to_s" do
    it "renders supported user-select values" do
      expected = <<-CSS
      p {
        user-select: auto;
      }

      span {
        user-select: text;
      }

      div {
        user-select: none;
      }

      section {
        user-select: contain;
      }

      article {
        user-select: all;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
