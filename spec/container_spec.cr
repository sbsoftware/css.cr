require "./spec_helper"

module CSS::ContainerSpec
  class Style < CSS::Stylesheet
    rule div do
      container_type :normal
      container_type :size
      container_type :inline_size
      container_type :scroll_state, important: true
      container_name "sidebar"
      container_name :none
      container "sidebar"
      container "sidebar", :inline_size
      container_type :revert_layer
    end
  end

  describe "Style.to_s" do
    it "renders typed container properties" do
      expected = <<-CSS
      div {
        container-type: normal;
        container-type: size;
        container-type: inline-size;
        container-type: scroll-state !important;
        container-name: sidebar;
        container-name: none;
        container: sidebar;
        container: sidebar / inline-size;
        container-type: revert-layer;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
