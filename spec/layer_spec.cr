require "./spec_helper"

class LayerStyle < CSS::Stylesheet
  layer_order :reset, :base_layer

  layer :base_layer do
    rule body do
      margin 0
    end

    supports(decl(:display, :grid)) do
      rule ".grid" do
        display :grid
      end
    end
  end

  media(max_width 600.px) do
    layer do
      rule body do
        margin 10.px
      end
    end
  end
end

describe "LayerStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    @layer reset, base-layer;

    @layer base-layer {
      body {
        margin: 0;
      }

      @supports (display: grid) {
        .grid {
          display: grid;
        }
      }
    }

    @media (max-width: 600px) {
      @layer {
        body {
          margin: 10px;
        }
      }
    }
    CSS

    LayerStyle.to_s.should eq(expected)
  end
end
