require "./spec_helper"

module CSS::GridTemplateColumnsSpec
  class Style < CSS::Stylesheet
    rule div do
      grid_template_columns :none
      grid_template_columns line_names(:start), 1.fr, line_names(:end)
      grid_template_columns minmax(120.px, 1.fr), fit_content(240.px)
      grid_template_columns repeat(3, line_names(:col_start), 1.fr, line_names(:col_end))
      grid_template_columns repeat(:auto_fit, 200.px)
      grid_template_columns repeat(:auto_fit, minmax(min(380.px, 100.percent), 1.fr))
      grid_template_columns :subgrid, line_names(:alpha, :beta), repeat(2, line_names(:gamma))
      grid_template_columns :masonry
    end
  end

  describe "Style.to_s" do
    it "renders grid-template-columns values" do
      expected = <<-CSS
      div {
        grid-template-columns: none;
        grid-template-columns: [start] 1fr [end];
        grid-template-columns: minmax(120px, 1fr) fit-content(240px);
        grid-template-columns: repeat(3, [col_start] 1fr [col_end]);
        grid-template-columns: repeat(auto-fit, 200px);
        grid-template-columns: repeat(auto-fit, minmax(min(380px, 100%), 1fr));
        grid-template-columns: subgrid [alpha beta] repeat(2, [gamma]);
        grid-template-columns: masonry;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
