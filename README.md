# css.cr

Create CSS stylesheets in pure Crystal

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     css:
       github: sbsoftware/css.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "css"

class Style < CSS::Stylesheet
  rule div do
    display :block
  end
end

# div {
#   display: block;
# }
puts Style
```

### Nested Rules

Similar to modern [CSS nesting](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_nesting), the `rule` directive can be nested. The resulting CSS will print a dedicated rule with both the parent and the child selector appended, to support older browsers.

```crystal
class Style < CSS::Stylesheet
  rule div do
    display :block

    rule p do
      display :block
    end
  end
end

# div {
#   display: block;
# }
#
# div p {
#   display: block;
# }
puts Style
```

### Media Queries

Define media blocks inline with your stylesheet so breakpoints live next to the rules they affect.

```crystal
class Responsive < CSS::Stylesheet
  rule div do
    font_size 16.px
  end

  media(max_width 600.px) do
    rule div do
      font_size 12.px
    end
  end
end
```

### Custom Selectors, Attributes, and Pseudo Elements

Use `css_class`/`css_id` helpers to generate consistent names, combine selectors, and target pseudo elements or attribute selectors.

```crystal
css_class Card
css_id Hero

class Selectors < CSS::Stylesheet
  rule Card do
    display :block
  end

  rule div > Card && "[data-state='active']" do
    opacity 1
  end

  rule Hero <= :before do
    content "\"★\""
    color :gold
  end
end
```

### Calculations and Unit Arithmetic

Do math directly on units or wrap complex expressions with `calc`.

```crystal
class Spacing < CSS::Stylesheet
  rule section do
    margin_left 8.px * -1      # => -8px
    padding_top 2.cm / 2       # => 1.0cm
    width calc(100.percent - 20.px)
  end
end
```

### Backgrounds and Gradients

Compose layered backgrounds, linear/radial gradients, and opacity values with readable builders.

```crystal
class HeroBackground < CSS::Stylesheet
  rule header do
    background linear_gradient(:to_right, {"#fff", 0.percent}, {"#000", 75.percent})
    background_image radial_gradient(:circle, :closest_side, at(:center), {"red", 10.percent}, {"blue", 90.percent})
    background_repeat :no_repeat
    opacity 0.9
  end
end
```

### Colors with `rgb()`

Build RGB and RGBA values without string concatenation.

```crystal
class Palette < CSS::Stylesheet
  rule button do
    color rgb(255, 128, 128)
    background_color rgb(10, 20, 30, alpha: 50.percent)
    border_color rgb(0, 0, 0, alpha: 25.percent)
  end
end
```

### Aspect Ratios with `ratio`

Use `ratio(numerator, denominator)` for the CSS `aspect-ratio` property (also works with plain numbers or math).

```crystal
class MediaBlocks < CSS::Stylesheet
  rule iframe do
    aspect_ratio ratio(16, 9)
  end

  rule img do
    aspect_ratio 4.0 / 3
  end
end
```

### Fonts and Assets

Declare `@font-face` blocks and reuse the family in later rules.

```crystal
class Typography < CSS::Stylesheet
  font_face MyFont, name: "MyFont" do
    src local("MyFont"), url("/assets/my_font.ttf")
  end

  rule body do
    font_family MyFont, "Verdana", :sans_serif
  end
end
```

## Contributing

1. Fork it (<https://github.com/sbsoftware/css.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Stefan Bilharz](https://github.com/sbsoftware) - creator and maintainer
