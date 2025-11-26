require "./spec_helper"

module CSS::TransformSpec
  class Style < CSS::Stylesheet
    rule ".card" do
      transform perspective(500.px)
      transform scale(2)
      transform scale(2, 0.5)
      transform translate(10.px)
      transform translate(2.rem, 50.percent)
      transform rotate_x(45.deg), rotate_y(0.5.turn), rotate_z(90.deg)
      transform perspective(250.px), scale(1.5), translate(1.ch, 25.percent), rotate_x(15.deg), rotate_y(30.deg), rotate_z(45.deg), scale(0.75)
      transform :none
      transform rotate(30.deg)
      transform rotate3d(1, 0, 0, 15.deg)
      transform translate_x(5.vw)
      transform translate_y(10.px)
      transform translate_z(2.rem)
      transform translate3d(1.px, 2.percent, 3.px)
      transform scale_x(1.1)
      transform scale_y(0.9)
      transform scale_z(1.2)
      transform scale3d(1, 2, 3)
      transform skew(25.deg, 10.deg)
      transform skew_x(15.deg)
      transform skew_y(5.deg)
      transform matrix(1, 0, 0, 1, 10, 20)
      transform matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 10, 20, 30, 1)
    end
  end

  describe "Style.to_s" do
    it "renders transform functions" do
      expected = <<-CSS
      .card {
        transform: perspective(500px);
        transform: scale(2);
        transform: scale(2, 0.5);
        transform: translate(10px);
        transform: translate(2rem, 50%);
        transform: rotateX(45deg) rotateY(0.5turn) rotateZ(90deg);
        transform: perspective(250px) scale(1.5) translate(1ch, 25%) rotateX(15deg) rotateY(30deg) rotateZ(45deg) scale(0.75);
        transform: none;
        transform: rotate(30deg);
        transform: rotate3d(1, 0, 0, 15deg);
        transform: translateX(5vw);
        transform: translateY(10px);
        transform: translateZ(2rem);
        transform: translate3d(1px, 2%, 3px);
        transform: scaleX(1.1);
        transform: scaleY(0.9);
        transform: scaleZ(1.2);
        transform: scale3d(1, 2, 3);
        transform: skew(25deg, 10deg);
        transform: skewX(15deg);
        transform: skewY(5deg);
        transform: matrix(1, 0, 0, 1, 10, 20);
        transform: matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 10, 20, 30, 1);
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
