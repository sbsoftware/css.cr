require "./spec_helper"

class ObjectFitStyle < CSS::Stylesheet
  rule img do
    object_fit :fill
    object_fit :contain
    object_fit :cover
    object_fit :none
    object_fit :scale_down
  end
end

describe "ObjectFitStyle.to_s" do
  it "should return the correct CSS" do
    expected = <<-CSS
    img {
      object-fit: fill;
      object-fit: contain;
      object-fit: cover;
      object-fit: none;
      object-fit: scale-down;
    }
    CSS

    ObjectFitStyle.to_s.should eq(expected)
  end
end
