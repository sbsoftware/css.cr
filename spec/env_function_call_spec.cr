require "./spec_helper"

module CSS::EnvFunctionCallSpec
  class Style < CSS::Stylesheet
    rule main do
      padding_top env(:safe_area_inset_top)
      padding_right env(:safe_area_inset_right, fallback: 1.em)
      margin_bottom env(:safe_area_max_inset_bottom, fallback: 0)
      width env(:viewport_segment_width, 0, 1, fallback: 40.percent)
      max_width calc(100.percent - env(:safe_area_inset_left))
      grid_template_columns env(:safe_area_inset_left), 1.fr
      line_height env(:preferred_text_scale, fallback: 1)
      background_color env(:titlebar_area_width, fallback: "transparent")
      top env(:keyboard_inset_top)
    end
  end

  describe "env() function" do
    it "renders typed environment variables and fallbacks" do
      expected = <<-CSS
      main {
        padding-top: env(safe-area-inset-top);
        padding-right: env(safe-area-inset-right, 1em);
        margin-bottom: env(safe-area-max-inset-bottom, 0);
        width: env(viewport-segment-width 0 1, 40%);
        max-width: calc(100% - env(safe-area-inset-left));
        grid-template-columns: env(safe-area-inset-left) 1fr;
        line-height: env(preferred-text-scale, 1);
        background-color: env(titlebar-area-width, transparent);
        top: env(keyboard-inset-top);
      }
      CSS

      Style.to_s.should eq(expected)
    end

    it "validates viewport segment indices" do
      expect_raises(ArgumentError, "viewport-segment-width requires exactly two non-negative indices") { CSS::EnvFunctionCall.new(:viewport_segment_width) }
      expect_raises(ArgumentError, "viewport-segment-width requires exactly two non-negative indices") { CSS::EnvFunctionCall.new(:viewport_segment_width, 0, -1) }
    end

    it "rejects indices for non-array environment variables" do
      expect_raises(ArgumentError, "safe-area-inset-top does not accept indices") { CSS::EnvFunctionCall.new(:safe_area_inset_top, 0, 0) }
    end
  end
end
