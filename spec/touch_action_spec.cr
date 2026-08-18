require "./spec_helper"

module CSS::TouchActionSpec
  class Style < CSS::Stylesheet
    rule div do
      touch_action :auto
      touch_action :none
      touch_action :manipulation
      touch_action :pan_x, :pan_y
      touch_action :pan_left, :pan_down, :pinch_zoom
      touch_action :pan_right, :pan_up, :double_tap_zoom, important: true
      touch_action :revert_layer
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
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end

  describe "touch_action macro validation" do
    it "rejects raw string values" do
      sample = <<-CRYSTAL
      require "./src/css"

      class InvalidTouchActionStyle < CSS::Stylesheet
        rule div do
          touch_action "pan-x pan-y"
        end
      end

      InvalidTouchActionStyle.to_s
      CRYSTAL

      output = IO::Memory.new
      status = Process.run("crystal", ["eval", sample], output: output, error: output)
      status.success?.should be_false
      output.to_s.should contain("touch_action does not accept raw String values")
    end

    it "rejects invalid value combinations" do
      sample = <<-CRYSTAL
      require "./src/css"

      class InvalidTouchActionStyle < CSS::Stylesheet
        rule div do
          touch_action :auto, :pan_x
        end
      end

      InvalidTouchActionStyle.to_s
      CRYSTAL

      output = IO::Memory.new
      status = Process.run("crystal", ["eval", sample], output: output, error: output)
      status.success?.should be_false
      output.to_s.should contain("\"auto\" cannot be combined with other touch-action values")
    end

    it "rejects duplicate values" do
      sample = <<-CRYSTAL
      require "./src/css"

      class InvalidTouchActionStyle < CSS::Stylesheet
        rule div do
          touch_action :pan_x, :pan_x
        end
      end

      InvalidTouchActionStyle.to_s
      CRYSTAL

      output = IO::Memory.new
      status = Process.run("crystal", ["eval", sample], output: output, error: output)
      status.success?.should be_false
      output.to_s.should contain("touch-action values must not be duplicated")
    end

    it "rejects ambiguous pan values" do
      sample = <<-CRYSTAL
      require "./src/css"

      class InvalidTouchActionStyle < CSS::Stylesheet
        rule div do
          touch_action :pan_x, :pan_left
        end
      end

      InvalidTouchActionStyle.to_s
      CRYSTAL

      output = IO::Memory.new
      status = Process.run("crystal", ["eval", sample], output: output, error: output)
      status.success?.should be_false
      output.to_s.should contain("touch-action accepts at most one horizontal pan value")
    end
  end
end
