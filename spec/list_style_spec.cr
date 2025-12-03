require "./spec_helper"

class ListStyleStyle < CSS::Stylesheet
  rule div do
    list_style :square
    list_style url("../img/shape.png")
    list_style :inside
    list_style :georgian, :outside
    list_style url("img/pip.svg"), :inside
    list_style :lower_roman, url("img/shape.png"), :outside
    list_style :none
    list_style_image :none
    list_style_image url("star-solid.gif")
    list_style_image linear_gradient(:to_left, {"#eee", 10.percent}, {"#111", 90.percent})
    list_style_position :inside
    list_style_position :outside
    list_style_type :none
    list_style_type :square
    list_style_type "x"
  end
end

describe "ListStyleStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      list-style: square;
      list-style: url("../img/shape.png");
      list-style: inside;
      list-style: georgian outside;
      list-style: url("img/pip.svg") inside;
      list-style: lower-roman url("img/shape.png") outside;
      list-style: none;
      list-style-image: none;
      list-style-image: url("star-solid.gif");
      list-style-image: linear-gradient(to left, #eee 10%, #111 90%);
      list-style-position: inside;
      list-style-position: outside;
      list-style-type: none;
      list-style-type: square;
      list-style-type: "x";
    }
    CSS

    ListStyleStyle.to_s.should eq(expected)
  end
end
