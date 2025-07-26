require "./spec_helper"

module CSS::BoxSizingSpec
  class Style < CSS::Stylesheet
    rule div do
      box_sizing :border_box
    end

    rule header do
      box_sizing :content_box
    end

    rule h1 do
      box_sizing :initial;
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        box-sizing: border-box;
      }

      header {
        box-sizing: content-box;
      }

      h1 {
        box-sizing: initial;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
