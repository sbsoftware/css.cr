# Units and calc()

## Unit helpers

Numeric literals expose CSS unit helpers:

- lengths: `.px`, `.rem`, `.em`, `.vh`, `.vw`, `.cm`, ...
- percentage: `.percent`
- angles: `.deg`, `.rad`, ...
- grid fraction: `.fr`

## Unit math

```crystal
class SpacingMath < CSS::Stylesheet
  rule section do
    margin_left -8.px
    padding_top 2.cm / 2
    width calc(100.percent - 20.px)
  end
end
```

Output:

```css
section {
  margin-left: -8px;
  padding-top: 1.0cm;
  width: calc(100% - 20px);
}
```

## Grid math helpers

```crystal
class GridTrackExample < CSS::Stylesheet
  rule main do
    grid_template_columns repeat(12, minmax(0, 1.fr))
  end
end
```

## Environment variables

Use `env` with a typed `CSS::Enums::EnvVariable` value. Viewport segment variables require two non-negative indices.

```crystal
class SafeAreaExample < CSS::Stylesheet
  rule main do
    padding_top env(:safe_area_inset_top, fallback: 0.px)
    width env(:viewport_segment_width, 0, 0, fallback: 100.percent)
  end
end
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `padding: 16px;` | `padding 16.px` |
| `padding-top: env(safe-area-inset-top, 0px);` | `padding_top env(:safe_area_inset_top, fallback: 0.px)` |
| `width: calc(100% - 20px);` | `width calc(100.percent - 20.px)` |
| `grid-template-columns: repeat(12, minmax(0, 1fr));` | `grid_template_columns repeat(12, minmax(0, 1.fr))` |
