require "./spec_helper"

module CSS::BackgroundSpec
  class Style < CSS::Stylesheet
    rule div do
      background :red;
      background url("test.jpg"), :repeat_y
      background :border_box, "#A0A0A0"
      background :no_repeat, :center, url("ape.png")
      background "#eeeeee", 35.percent, url("assets/this_dude.svg")

      background_attachment :fixed
      background_attachment :local
      background_attachment :scroll

      background_blend_mode :color_dodge
      background_blend_mode :luminosity

      background_clip :border_box
      background_clip :padding_box
      background_clip :content_box
      background_clip :text
      background_clip :border_area

      background_color :blue
      background_color "#EEEEEE"

      background_image url("assets/my_pic.jpg")
      background_image linear_gradient(:to_right, {"red", 0.percent}, {"blue", 100.percent})
      background_image radial_gradient(
        :circle,
        :closest_side,
        at(:center),
        {"yellow", 10.percent},
        {"green", 90.percent}
      )
      background_image radial_gradient(
        50.px,
        {"orange", 0.percent},
        {"purple", 100.percent}
      )
      background_image radial_gradient(
        :ellipse,
        40.percent,
        60.percent,
        {"#123456", 0.percent},
        {"#abcdef", 100.percent}
      )
      background_image conic_gradient({"red", 0.deg}, {"blue", 180.deg}, {"red", 360.deg})
      background_image conic_gradient(from(45.deg), {"#fff", 0.percent}, {"#000", 100.percent})
      background_image conic_gradient(at(:left, 25.percent, :top, 40.percent), {"gold", 0.deg}, {"navy", 270.deg})
      background_image conic_gradient(from(0.25.turn), at(:center), {"#f00", 0.deg, 90.deg}, {"#0f0", 90.deg, 180.deg}, {"#00f", 180.deg, 360.deg})

      background_origin :border_box
      background_origin :padding_box
      background_origin :content_box

      background_position :center
      background_position :center, :center
      background_position :top, :center
      background_position :center, :left
      background_position :top, 50.percent
      background_position 50.percent, :top
      background_position 50.percent, 50.percent

      background_position_x :right
      background_position_x 25.percent

      background_position_y :bottom
      background_position_y 75.percent

      background_repeat :no_repeat;
      background_repeat :repeat;
      background_repeat :repeat_x;
      background_repeat :repeat_y;
      background_repeat :space;
      background_repeat :round;

      background_size :cover
      background_size :contain
      background_size 100.percent
      background linear_gradient(45.deg, {"#fff", 0.percent}, {"#000", 75.percent})
      background radial_gradient(
        :ellipse,
        at(:center),
        {"#eee", 5.percent},
        {"#111", 95.percent}
      )
      background conic_gradient(from(90.deg), at(25.percent, 75.percent), {"#111", 0.percent}, {"#eee", 100.percent})

      opacity 1
      opacity 0.75
      opacity 90.percent
      opacity 0
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        background: red;
        background: url("test.jpg") repeat-y;
        background: border-box #A0A0A0;
        background: no-repeat center url("ape.png");
        background: #eeeeee 35% url("assets/this_dude.svg");
        background-attachment: fixed;
        background-attachment: local;
        background-attachment: scroll;
        background-blend-mode: color-dodge;
        background-blend-mode: luminosity;
        background-clip: border-box;
        background-clip: padding-box;
        background-clip: content-box;
        background-clip: text;
        background-clip: border-area;
        background-color: blue;
        background-color: #EEEEEE;
        background-image: url("assets/my_pic.jpg");
        background-image: linear-gradient(to right, red 0%, blue 100%);
        background-image: radial-gradient(circle closest-side at center, yellow 10%, green 90%);
        background-image: radial-gradient(50px, orange 0%, purple 100%);
        background-image: radial-gradient(ellipse 40% 60%, #123456 0%, #abcdef 100%);
        background-image: conic-gradient(red 0deg, blue 180deg, red 360deg);
        background-image: conic-gradient(from 45deg, #fff 0%, #000 100%);
        background-image: conic-gradient(at left 25% top 40%, gold 0deg, navy 270deg);
        background-image: conic-gradient(from 0.25turn at center, #f00 0deg 90deg, #0f0 90deg 180deg, #00f 180deg 360deg);
        background-origin: border-box;
        background-origin: padding-box;
        background-origin: content-box;
        background-position: center;
        background-position: center center;
        background-position: top center;
        background-position: center left;
        background-position: top 50%;
        background-position: 50% top;
        background-position: 50% 50%;
        background-position-x: right;
        background-position-x: 25%;
        background-position-y: bottom;
        background-position-y: 75%;
        background-repeat: no-repeat;
        background-repeat: repeat;
        background-repeat: repeat-x;
        background-repeat: repeat-y;
        background-repeat: space;
        background-repeat: round;
        background-size: cover;
        background-size: contain;
        background-size: 100%;
        background: linear-gradient(45deg, #fff 0%, #000 75%);
        background: radial-gradient(ellipse at center, #eee 5%, #111 95%);
        background: conic-gradient(from 90deg at 25% 75%, #111 0%, #eee 100%);
        opacity: 1;
        opacity: 0.75;
        opacity: 90%;
        opacity: 0;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
