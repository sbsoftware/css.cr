require "./spec_helper"

module CSS::TouchActionSpec
  class Style < CSS::Stylesheet
    rule div do
      touch_action :auto
      touch_action :none
      touch_action :manipulation
      touch_action :pan_x, :pan_y
      touch_action :pan_left, :pan_down, :pinch_zoom
      touch_action CSS::TouchAction::PanRight, CSS::TouchAction::PanUp, CSS::TouchAction::DoubleTapZoom, important: true
      touch_action :revert_layer
      touch_action "pan-x pan-y"
    end
  end

  describe "Style.to_s" do
    it "renders supported touch-action values and combinations" do
      expected = <<-CSS
      div {
        touch-action: auto;
        touch-action: none;
        touch-action: manipulation;
        touch-action: pan-x pan-y;
        touch-action: pan-left pan-down pinch-zoom;
        touch-action: pan-right pan-up double-tap-zoom !important;
        touch-action: revert-layer;
        touch-action: "pan-x pan-y";
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end

  describe ".touch_action" do
    it "rejects exclusive values in combinations" do
      expect_raises(ArgumentError, "auto cannot be combined with other touch-action values") { CSS::Stylesheet._touch_action(:auto, :pan_x) }
      expect_raises(ArgumentError, "none cannot be combined with other touch-action values") { CSS::Stylesheet._touch_action(:none, :pinch_zoom) }
      expect_raises(ArgumentError, "manipulation cannot be combined with other touch-action values") { CSS::Stylesheet._touch_action(:manipulation, :double_tap_zoom) }
    end

    it "rejects duplicate and ambiguous pan values" do
      expect_raises(ArgumentError, "touch-action values must not be duplicated") { CSS::Stylesheet._touch_action(:pan_x, :pan_x) }
      expect_raises(ArgumentError, "touch-action accepts at most one horizontal pan value") { CSS::Stylesheet._touch_action(:pan_x, :pan_left) }
      expect_raises(ArgumentError, "touch-action accepts at most one vertical pan value") { CSS::Stylesheet._touch_action(:pan_y, :pan_down) }
    end
  end
end
