# Gradients and Colors

## RGB values

```crystal
class Palette < CSS::Stylesheet
  rule button do
    color rgb(255, 128, 128)
    background_color rgb(20, 30, 40, alpha: 60.percent)
  end
end
```

## Linear gradients

```crystal
class HeroGradient < CSS::Stylesheet
  rule header do
    background linear_gradient(:to_right, {"#0ea5e9", 0.percent}, {"#2563eb", 100.percent})
  end
end
```

## Radial gradients and `at(...)`

```crystal
class RadialGradientStyle < CSS::Stylesheet
  rule section do
    background_image radial_gradient(
      :circle,
      :closest_side,
      at(:center),
      {"#fef08a", 10.percent},
      {"#f97316", 90.percent}
    )
  end
end
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `color: rgb(255, 128, 128);` | `color rgb(255, 128, 128)` |
| `background: linear-gradient(to right, #0ea5e9 0%, #2563eb 100%);` | `background linear_gradient(:to_right, {"#0ea5e9", 0.percent}, {"#2563eb", 100.percent})` |
| `radial-gradient(circle closest-side at center, ...)` | `radial_gradient(:circle, :closest_side, at(:center), ...)` |
