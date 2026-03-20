# Using !important

Most property helpers accept a named `important` argument.

```crystal
class ImportantExample < CSS::Stylesheet
  rule ".card" do
    display :block, important: true
    grid_template_columns 1.fr, important: true
    transform translate(10.px), important: true
  end
end
```

Output:

```css
.card {
  display: block !important;
  grid-template-columns: 1fr !important;
  transform: translate(10px) !important;
}
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `display: block !important;` | `display :block, important: true` |
| `transform: translate(10px) !important;` | `transform translate(10.px), important: true` |
