require "./spec_helper"

module CSS::ImportantSpec
  class Style < CSS::Stylesheet
    rule ".card" do
      display :block, important: true
      grid_template_columns 1.fr, important: true
      transform translate(10.px), important: true
    end
  end

  describe "Style.to_s" do
    it "renders !important declarations" do
      expected = <<-CSS
      .card {
        display: block !important;
        grid-template-columns: 1fr !important;
        transform: translate(10px) !important;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
