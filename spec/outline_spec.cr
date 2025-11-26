require "./spec_helper"

class OutlineStyleSheet < CSS::Stylesheet
  rule div do
    outline :dotted
    outline :thick
    outline 2.px, :solid
    outline :double, "#123456"
    outline "#abcdef", :ridge, 3.px
    outline :auto, :thin, :blue

    outline_color :red
    outline_color "#00ff00"
    outline_style :groove
    outline_style :auto
    outline_width :thin
    outline_width 4.px
    outline_offset 2.px
    outline_offset 0
  end
end

describe "OutlineStyleSheet.to_s" do
  it "renders outline properties" do
    expected = <<-CSS
    div {
      outline: dotted;
      outline: thick;
      outline: 2px solid;
      outline: double #123456;
      outline: #abcdef ridge 3px;
      outline: auto thin blue;
      outline-color: red;
      outline-color: #00ff00;
      outline-style: groove;
      outline-style: auto;
      outline-width: thin;
      outline-width: 4px;
      outline-offset: 2px;
      outline-offset: 0;
    }
    CSS

    OutlineStyleSheet.to_s.should eq(expected)
  end
end
