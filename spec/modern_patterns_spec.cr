require "./spec_helper"

class ModernPatternsStyle < CSS::Stylesheet
  rule h1 do
    font_size clamp(1.rem, calc(2.vw + 1.rem), 3.rem)
  end

  supports(decl(:display, :grid) & decl(:gap, 1.rem)) do
    rule div do
      display :grid
      gap 1.rem
    end

    media(max_width 600.px) do
      rule div do
        display :block
      end
    end
  end

  layer_order :reset, :base

  layer :base do
    rule body do
      margin 0
    end
  end
end

describe "ModernPatternsStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    h1 {
      font-size: clamp(1rem, calc(2vw + 1rem), 3rem);
    }

    @supports (display: grid) and (gap: 1rem) {
      div {
        display: grid;
        gap: 1rem;
      }

      @media (max-width: 600px) {
        div {
          display: block;
        }
      }
    }

    @layer reset, base;

    @layer base {
      body {
        margin: 0;
      }
    }
    CSS

    ModernPatternsStyle.to_s.should eq(expected)
  end
end
