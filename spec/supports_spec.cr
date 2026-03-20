require "./spec_helper"

class SupportsStyle < CSS::Stylesheet
  supports(selector("a > b")) do
    rule a do
      color :red
    end
  end

  supports(raw("(display: grid)")) do
    rule div do
      display :grid
    end
  end

  supports(group(decl(:display, :grid) | decl(:display, :flex)) & decl(:gap, 1.rem)) do
    rule ".x" do
      opacity 1
    end
  end

  supports(negate(decl(:display, :grid) & decl(:gap, 1.rem))) do
    rule ".n" do
      display :block
    end
  end

  supports(decl(:display, :grid)) do
    supports(decl(:gap, 1.rem)) do
      rule div do
        gap 1.rem
      end
    end
  end
end

describe "SupportsStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    @supports selector(a > b) {
      a {
        color: red;
      }
    }

    @supports (display: grid) {
      div {
        display: grid;
      }
    }

    @supports ((display: grid) or (display: flex)) and (gap: 1rem) {
      .x {
        opacity: 1;
      }
    }

    @supports not ((display: grid) and (gap: 1rem)) {
      .n {
        display: block;
      }
    }

    @supports (display: grid) {
      @supports (gap: 1rem) {
        div {
          gap: 1rem;
        }
      }
    }
    CSS

    SupportsStyle.to_s.should eq(expected)
  end
end
