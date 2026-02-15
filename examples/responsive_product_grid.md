# Responsive Product Grid

Grid layout that progressively reduces columns and spacing at narrower breakpoints.

## Crystal DSL

```crystal
require "css"

class ProductGridResponsiveExample < CSS::Stylesheet
  rule ".product-grid" do
    display :grid
    grid_template_columns repeat(4, minmax(0, 1.fr))
    gap 20.px
  end

  media(max_width 1024.px) do
    rule ".product-grid" do
      grid_template_columns repeat(2, minmax(0, 1.fr))
    end
  end

  media(max_width 640.px) do
    rule ".product-grid" do
      grid_template_columns 1.fr
      gap 12.px
    end
  end
end

puts ProductGridResponsiveExample
```

## Rendered CSS

```css
.product-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 20px;
}

@media (max-width: 1024px) {
  .product-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .product-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }
}
```
