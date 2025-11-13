require "./spec_helper"

class FontFaceStyle < CSS::Stylesheet
  font_face MyFont, name: "MyFont" do
    src local("MyFont"), url("/assets/my_font.ttf")
  end

  rule div do
    font_family MyFont, "Verdana", :sans_serif
  end
end

describe "FontFaceStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    @font-face {
      font-family: "MyFont";
      src: local("MyFont"), url("/assets/my_font.ttf");
    }

    div {
      font-family: "MyFont", "Verdana", sans-serif;
    }
    CSS

    FontFaceStyle.to_s.should eq(expected)
  end
end
