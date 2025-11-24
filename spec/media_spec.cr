require "./spec_helper"

class MediaStyle < CSS::Stylesheet
  rule div do
    font_size 16.px
  end

  media(max_width 400.px) do
    rule div do
      font_size 12.px
    end
  end

  media(max_width(1600.px) & min_width(1200.px)) do
    rule div do
      font_size 18.px
    end
  end

  media(min_width(800.px) & max_width(1000.px) & min_height(800.px) & max_height(1600.px)) do
    rule div do
      display :none
    end
  end
end

describe "MediaStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      font-size: 16px;
    }

    @media (max-width: 400px) {
      div {
        font-size: 12px;
      }
    }

    @media (max-width: 1600px) and (min-width: 1200px) {
      div {
        font-size: 18px;
      }
    }

    @media (min-width: 800px) and (max-width: 1000px) and (min-height: 800px) and (max-height: 1600px) {
      div {
        display: none;
      }
    }
    CSS

    MediaStyle.to_s.should eq(expected)
  end
end
