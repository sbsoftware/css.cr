require "./spec_helper"

module CSS::UnitsSpec
  class Style < CSS::Stylesheet
    rule div do
      width 100.percent
      max_width 100.vw
      height 20.em
      min_height 100.px
      max_height 100.vh
    end

    rule section do
      width 100.vmax
      min_width 16.pc
      max_width 100.cm
      height 100.dvh
      min_height 7.fr
      max_height 4.ex
    end

    rule h1 do
      width 0
      height 0
    end
  end

  describe "Style.to_s" do
    it "should return the correct CSS" do
      expected = <<-CSS
      div {
        width: 100%;
        max-width: 100vw;
        height: 20em;
        min-height: 100px;
        max-height: 100vh;
      }

      section {
        width: 100vmax;
        min-width: 16pc;
        max-width: 100cm;
        height: 100dvh;
        min-height: 7fr;
        max-height: 4ex;
      }

      h1 {
        width: 0;
        height: 0;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
