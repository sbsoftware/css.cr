require "./spec_helper"

module CSS::GridTemplateRowsSpec
  class Style < CSS::Stylesheet
    rule div do
      grid_template_rows :none
      grid_template_rows line_names(:start), 1.fr, line_names(:end)
      grid_template_rows repeat(:auto_fit, minmax(min(380.px, 100.percent), 1.fr))
      grid_template_rows :subgrid, line_names(:alpha, :beta), repeat(2, line_names(:gamma))
      grid_template_rows :masonry
    end
  end

  describe "Style.to_s" do
    it "renders grid-template-rows values" do
      expected = <<-CSS
      div {
        grid-template-rows: none;
        grid-template-rows: [start] 1fr [end];
        grid-template-rows: repeat(auto-fit, minmax(min(380px, 100%), 1fr));
        grid-template-rows: subgrid [alpha beta] repeat(2, [gamma]);
        grid-template-rows: masonry;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
