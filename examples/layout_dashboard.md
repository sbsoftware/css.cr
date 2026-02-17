# Dashboard Layout

Two-column application shell with constrained content width and full viewport height.

## Crystal DSL

```crystal
require "css"

css_class AppShell
css_class Content

class DashboardLayoutExample < CSS::Stylesheet
  rule AppShell do
    display :grid
    grid_template_columns 240.px, 1.fr
    gap 24.px
    min_height 100.vh
    background_color "#f8fafc"

    rule Content do
      padding 24.px
      max_width 1200.px
      margin 0, :auto
    end
  end
end

puts DashboardLayoutExample
```

## Rendered CSS

```css
.app-shell {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 24px;
  min-height: 100vh;
  background-color: #f8fafc;
}

.app-shell .content {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
}
```
