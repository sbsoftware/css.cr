require "./spec_helper"

module CSS::AnimationSpec
  class Style < CSS::Stylesheet
    keyframes FadeIn, "fade-in" do
      step 0.percent do
        opacity 0
        transform translate_y(8.px)
      end

      step 50.percent do
        opacity 0.5
      end

      step 100.percent do
        opacity 1
        transform translate_y(0)
      end
    end

    keyframes SlideOut do
      from do
        opacity 1
      end

      to do
        opacity 0
      end
    end

    rule ".card" do
      animation_name FadeIn
      animation_duration 250.ms
      animation_timing_function cubic_bezier(0.4, 0, 0.2, 1)
      animation_delay 1.s
      animation_iteration_count :infinite
      animation_direction :alternate_reverse
      animation_fill_mode :both
      animation_play_state :running
      animation FadeIn, 250.ms, :ease_in_out, 1.s, :infinite, :alternate_reverse, :both, :running
    end

    rule ".toast" do
      animation_name "toast-enter"
      animation_duration 0
      animation_timing_function steps(4, :jump_end)
      animation_iteration_count 2
      animation "slide-out", 120.ms, :linear, 2, :reverse, :forwards, :paused
    end
  end

  describe "Style.to_s" do
    it "renders keyframes and typed animation properties" do
      expected = <<-CSS
      @keyframes fade-in {
        0% {
          opacity: 0;
          transform: translateY(8px);
        }

        50% {
          opacity: 0.5;
        }

        100% {
          opacity: 1;
          transform: translateY(0);
        }
      }

      @keyframes slide-out {
        from {
          opacity: 1;
        }

        to {
          opacity: 0;
        }
      }

      .card {
        animation-name: fade-in;
        animation-duration: 250ms;
        animation-timing-function: cubic-bezier(0.4, 0.0, 0.2, 1.0);
        animation-delay: 1s;
        animation-iteration-count: infinite;
        animation-direction: alternate-reverse;
        animation-fill-mode: both;
        animation-play-state: running;
        animation: fade-in 250ms ease-in-out 1s infinite alternate-reverse both running;
      }

      .toast {
        animation-name: toast-enter;
        animation-duration: 0;
        animation-timing-function: steps(4, jump-end);
        animation-iteration-count: 2;
        animation: slide-out 120ms linear 2 reverse forwards paused;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
