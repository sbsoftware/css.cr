require "./spec_helper"

module CSS::TransformOriginSpec
  class Style < CSS::Stylesheet
    rule ".origin" do
      transform_origin :left
      transform_origin :center
      transform_origin :right
      transform_origin :top
      transform_origin :bottom
      transform_origin 25.percent
      transform_origin :left, :top
      transform_origin :bottom, :right
      transform_origin 10.px, 20.percent
      transform_origin :right, 30.percent
      transform_origin 40.percent, :bottom
      transform_origin :center, :center, 5.px
      transform_origin :top, :left, -2.px
      transform_origin 25.percent, 75.percent, 0
      transform_origin :inherit
      transform_origin :revert_layer, important: true
    end
  end

  describe "Style.to_s" do
    it "renders typed keyword, position, z-offset, and global values" do
      expected = <<-CSS
      .origin {
        transform-origin: left;
        transform-origin: center;
        transform-origin: right;
        transform-origin: top;
        transform-origin: bottom;
        transform-origin: 25%;
        transform-origin: left top;
        transform-origin: bottom right;
        transform-origin: 10px 20%;
        transform-origin: right 30%;
        transform-origin: 40% bottom;
        transform-origin: center center 5px;
        transform-origin: top left -2px;
        transform-origin: 25% 75% 0;
        transform-origin: inherit;
        transform-origin: revert-layer !important;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
