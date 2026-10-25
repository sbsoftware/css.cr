require "./spec_helper"

module CSS::GridSpec
  class Style < CSS::Stylesheet
    rule div do
      grid_auto_flow :row
      grid_auto_flow :column, :dense
      grid_auto_columns 120.px, minmax(10.em, 1.fr)
      grid_auto_rows :auto, 1.fr
      grid_area 1, grid_line(:content_start), span(3, :content_end), :auto
      grid_column 2, span(2)
      grid_row :auto
      grid_template_areas "header header", "main sidebar"
      grid_template grid_tracks(100.px, 1.fr), grid_tracks(1.fr, 2.fr)
      grid_template grid_area_row("hero")
      grid_template grid_area_row("header header", 80.px, before: line_names(:top)), grid_area_row("main sidebar", 1.fr, after: line_names(:bottom)), columns: grid_tracks(2.fr, 1.fr)
      grid grid_tracks(100.px, 1.fr), grid_tracks(1.fr, 2.fr)
      grid grid_tracks(100.px), auto_flow(dense: true), grid_auto_tracks(1.fr)
      grid auto_flow, grid_auto_tracks(80.px), grid_tracks(1.fr, 2.fr)
    end
  end

  describe "Style.to_s" do
    it "renders typed grid properties and shorthands" do
      expected = <<-CSS
      div {
        grid-auto-flow: row;
        grid-auto-flow: column dense;
        grid-auto-columns: 120px minmax(10em, 1fr);
        grid-auto-rows: auto 1fr;
        grid-area: 1 / content-start / span 3 content-end / auto;
        grid-column: 2 / span 2;
        grid-row: auto;
        grid-template-areas: "header header" "main sidebar";
        grid-template: 100px 1fr / 1fr 2fr;
        grid-template: "hero";
        grid-template: [top] "header header" 80px "main sidebar" 1fr [bottom] / 2fr 1fr;
        grid: 100px 1fr / 1fr 2fr;
        grid: 100px / auto-flow dense 1fr;
        grid: auto-flow 80px / 1fr 2fr;
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end

  describe CSS::GridSpan do
    it "rejects invalid spans" do
      expect_raises(ArgumentError, "grid span requires a count or name") { CSS::GridSpan.new }
      expect_raises(ArgumentError, "grid span requires a positive count") { CSS::GridSpan.new(0) }
    end
  end
end
