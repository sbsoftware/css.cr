require "./spec_helper"

class JustifyItemsStyle < CSS::Stylesheet
  rule div do
    justify_items :normal
    justify_items :left
    justify_items :safe, :center
    justify_items :first, :baseline
    justify_items :legacy
    justify_items :legacy, :right
    justify_items :anchor_center
  end
end

describe "JustifyItemsStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    div {
      justify-items: normal;
      justify-items: left;
      justify-items: safe center;
      justify-items: first baseline;
      justify-items: legacy;
      justify-items: legacy right;
      justify-items: anchor-center;
    }
    CSS

    JustifyItemsStyle.to_s.should eq(expected)
  end
end
