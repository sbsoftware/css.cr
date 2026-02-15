# Ergonomics Map

## Audit: Top Friction Points

1. At-rules are represented as bare method names (`media`, `supports`, `layer`), which feels less CSS-like than `@media`, `@supports`, and `@layer`.
2. Layer ordering uses `layer_order`, which is descriptive but farther from the CSS at-rule mental model.
3. Support-condition helpers are short and terse (`decl`, `raw`, `group`, `negate`), which can be unclear at call sites with complex boolean expressions.

## Shipped Alias Layer (Non-breaking)

All existing APIs remain fully supported. The aliases below are additive adapters:

| Existing API | New alias | Purpose |
| --- | --- | --- |
| `media(...)` | `at_media(...)` | Closer mapping to `@media` |
| `supports(...)` | `at_supports(...)` | Closer mapping to `@supports` |
| `layer(...)` | `at_layer(...)` | Closer mapping to `@layer` |
| `layer_order(...)` | `at_layer_order(...)` | Closer mapping to `@layer ...;` ordering |
| `decl(...)` | `declaration(...)` | More explicit supports declaration helper |
| `selector(...)` | `selector_condition(...)` | Disambiguates supports selector condition |
| `raw(...)` | `raw_condition(...)` | Disambiguates raw supports condition |
| `group(...)` | `grouped(...)` | Reads like condition grouping |
| `negate(...)` | `not_condition(...)` | Reads like CSS `not` |

## Examples

```crystal
class ErgonomicStyle < CSS::Stylesheet
  at_layer_order :reset, :base

  at_layer :base do
    rule body do
      margin 0
    end
  end

  at_supports(declaration(:display, :grid) & declaration(:gap, 1.rem)) do
    at_media(max_width 600.px) do
      rule ".grid" do
        display :grid
      end
    end
  end
end
```
