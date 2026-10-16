require "./spec_helper"

module CSS::ContainerQueryUnitsSpec
  class Style < CSS::Stylesheet
    rule div do
      width 10.cqw
      height 20.cqh
      min_width 30.cqi
      min_height 40.cqb
      max_width 50.cqmin
      max_height 60.cqmax
      margin_left 8.cqw * 2
      margin_right calc(100.cqi - 2.rem)
      padding_inline min(5.cqmin, 24.px)
      padding_block clamp(10.px, 4.cqmax, 100.px)
    end
  end

  describe "container query length units" do
    it "serializes all units and composes with arithmetic and math functions" do
      expected = <<-CSS
      div {
        width: 10cqw;
        height: 20cqh;
        min-width: 30cqi;
        min-height: 40cqb;
        max-width: 50cqmin;
        max-height: 60cqmax;
        margin-left: 16cqw;
        margin-right: calc(100cqi - 2rem);
        padding-inline: min(5cqmin, 24px);
        padding-block: clamp(10px, 4cqmax, 100px);
      }
      CSS

      Style.to_s.should eq(expected)
    end

    it "preserves units for the browser to resolve against a query container or small viewport fallback" do
      1.cqw.to_css_value.should eq("1cqw")
      1.cqh.to_css_value.should eq("1cqh")
    end
  end
end
