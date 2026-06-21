require "./spec_helper"

module CSS::MathFunctionPropertySpec
  class Style < CSS::Stylesheet
    rule div do
      width min(24.rem, 100.percent), important: true
      min_width min(20.px, 50.percent)
      max_width min(90.vw, 1200.px)
      height min(30.vh, 400.px)
      margin min(2.rem, 5.percent)
      padding min(1.rem, 3.percent)
      border_width min(2.px, 0.25.rem)
      border_radius min(8.px, 2.percent)
      border_image_slice min(30.percent, 50.percent)
      background_size min(50.percent, 20.rem)
      background_position_x min(10.percent, 3.rem)
      column_gap min(2.rem, 5.percent)
      font_size min(4.vw, 2.rem)
      line_height min(150.percent, 2.rem)
      opacity min(50.percent, 0)
      transform rotate(min(45.deg, 0.25.turn))
      margin_left calc(100.percent - min(2.rem, 5.percent))
    end
  end

  describe "math functions in property values" do
    it "renders min() values in length, percentage, number, and angle properties" do
      expected = <<-CSS
      div {
        width: min(24rem, 100%) !important;
        min-width: min(20px, 50%);
        max-width: min(90vw, 1200px);
        height: min(30vh, 400px);
        margin: min(2rem, 5%);
        padding: min(1rem, 3%);
        border-width: min(2px, 0.25rem);
        border-radius: min(8px, 2%);
        border-image-slice: min(30%, 50%);
        background-size: min(50%, 20rem);
        background-position-x: min(10%, 3rem);
        column-gap: min(2rem, 5%);
        font-size: min(4vw, 2rem);
        line-height: min(150%, 2rem);
        opacity: min(50%, 0);
        transform: rotate(min(45deg, 0.25turn));
        margin-left: calc(100% - min(2rem, 5%));
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
