require "./spec_helper"

class ErgonomicsAliasStyle < CSS::Stylesheet
  at_layer_order :reset, :base_layer

  at_layer :base_layer do
    rule body do
      margin 0
    end
  end

  at_supports(declaration(:display, :grid) & declaration(:gap, 1.rem)) do
    at_media(max_width 600.px) do
      rule ".grid" do
        display :grid
      end
    end
  end

  at_supports(selector_condition("main > .item")) do
    rule ".item" do
      color :red
    end
  end

  at_supports(raw_condition("(display: subgrid)")) do
    rule ".fallback" do
      display :block
    end
  end

  at_supports(grouped(declaration(:display, :grid) | declaration(:display, :flex)) & not_condition(declaration(:gap, 1.rem))) do
    rule ".no-gap" do
      gap 0
    end
  end

  at_media(pointer :fine) do
    at_layer do
      rule button do
        cursor :pointer
      end
    end
  end
end

describe "ErgonomicsAliasStyle.to_s" do
  it "renders CSS-like alias entry points without changing output semantics" do
    expected = <<-CSS
    @layer reset, base-layer;

    @layer base-layer {
      body {
        margin: 0;
      }
    }

    @supports (display: grid) and (gap: 1rem) {
      @media (max-width: 600px) {
        .grid {
          display: grid;
        }
      }
    }

    @supports selector(main > .item) {
      .item {
        color: red;
      }
    }

    @supports (display: subgrid) {
      .fallback {
        display: block;
      }
    }

    @supports ((display: grid) or (display: flex)) and not (gap: 1rem) {
      .no-gap {
        gap: 0;
      }
    }

    @media (pointer: fine) {
      @layer {
        button {
          cursor: pointer;
        }
      }
    }
    CSS

    ErgonomicsAliasStyle.to_s.should eq(expected)
  end
end
