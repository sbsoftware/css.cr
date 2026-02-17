# Marketing Hero Gradients

Hero section background with a linear gradient plus radial glow overlay.

## Crystal DSL

```crystal
require "css"

css_class MarketingHero
css_class Glow

class GradientHeroExample < CSS::Stylesheet
  rule MarketingHero do
    background linear_gradient(
      :to_right,
      {"#0ea5e9", 0.percent},
      {"#2563eb", 55.percent},
      {"#1d4ed8", 100.percent}
    )
    color :white
    padding 80.px, 24.px

    rule Glow do
      background_image radial_gradient(
        :circle,
        :farthest_corner,
        at(:top, :right),
        {rgb(255, 255, 255, alpha: 40.percent), 0.percent},
        {rgb(255, 255, 255, alpha: 0.percent), 70.percent}
      )
    end
  end
end

puts GradientHeroExample
```

## Rendered CSS

```css
.marketing-hero {
  background: linear-gradient(to right, #0ea5e9 0%, #2563eb 55%, #1d4ed8 100%);
  color: white;
  padding: 80px 24px;
}

.marketing-hero .glow {
  background-image: radial-gradient(circle farthest-corner at top right, rgb(255, 255, 255, 40%) 0%, rgb(255, 255, 255, 0%) 70%);
}
```
