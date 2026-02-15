# Media Queries

Use `media(...)` in a stylesheet. Query helpers are available inside the expression block.

## Supported query helpers

- `max_width(...)`
- `min_width(...)`
- `max_height(...)`
- `min_height(...)`
- `hover(...)`
- `any_hover(...)`
- `pointer(...)`
- `any_pointer(...)`

## Examples

```crystal
class Responsive < CSS::Stylesheet
  rule div do
    font_size 16.px
  end

  media(max_width 700.px) do
    rule div do
      font_size 14.px
    end
  end

  media(min_width(900.px) & max_width(1200.px)) do
    rule div do
      font_size 18.px
    end
  end

  media(pointer :fine) do
    rule button do
      cursor :pointer
    end
  end
end
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `@media (max-width: 700px) { ... }` | `media(max_width 700.px) do ... end` |
| `@media (min-width: 900px) and (max-width: 1200px) { ... }` | `media(min_width(900.px) & max_width(1200.px)) do ... end` |
| `@media (pointer: fine) { ... }` | `media(pointer :fine) do ... end` |
