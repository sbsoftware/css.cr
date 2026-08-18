require "./spec_helper"

class JustifySelfStyle < CSS::Stylesheet
  rule div do
    justify_self :auto
    justify_self :normal
    justify_self :stretch
    justify_self :center
    justify_self :safe, :self_end
    justify_self :unsafe, :right
    justify_self :first, :baseline
    justify_self :last, :baseline
    justify_self :anchor_center
    justify_self :inherit
  end
end

describe "JustifySelfStyle.to_s" do
  it "serializes typed single- and multi-value forms" do
    expected = <<-CSS
    div {
      justify-self: auto;
      justify-self: normal;
      justify-self: stretch;
      justify-self: center;
      justify-self: safe self-end;
      justify-self: unsafe right;
      justify-self: first baseline;
      justify-self: last baseline;
      justify-self: anchor-center;
      justify-self: inherit;
    }
    CSS

    JustifySelfStyle.to_s.should eq(expected)
  end
end
