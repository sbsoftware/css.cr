# Cookbook

Practical patterns you can copy into real stylesheets.

## 1) Responsive card grid

```css
.cards {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 900px) {
  .cards {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
```

```crystal
css_class Cards

class ResponsiveCards < CSS::Stylesheet
  rule Cards do
    display :grid
    grid_template_columns repeat(3, minmax(0, 1.fr))
    gap 16.px
  end

  media(max_width 900.px) do
    rule Cards do
      grid_template_columns repeat(2, minmax(0, 1.fr))
    end
  end
end
```

## 2) Pressed button state

```css
.button[aria-pressed='true'] {
  background-color: #2563eb !important;
  color: white !important;
}
```

```crystal
css_class Button

class PressedButton < CSS::Stylesheet
  rule Button && "[aria-pressed='true']" do
    background_color "#2563eb", important: true
    color :white, important: true
  end
end
```

## 3) Hero gradient background

```css
.hero {
  background: linear-gradient(to right, #0ea5e9 0%, #2563eb 100%);
}
```

```crystal
css_class Hero

class HeroBackground < CSS::Stylesheet
  rule Hero do
    background linear_gradient(:to_right, {"#0ea5e9", 0.percent}, {"#2563eb", 100.percent})
  end
end
```

## 4) Embedded media ratio

```css
.video {
  aspect-ratio: 16 / 9;
  width: 100%;
}
```

```crystal
css_class Video

class EmbeddedMedia < CSS::Stylesheet
  rule Video do
    aspect_ratio ratio(16, 9)
    width 100.percent
  end
end
```

## 5) Local font plus fallback stack

```css
@font-face {
  font-family: "UiSans";
  src: local("UiSans"), url("/assets/ui-sans.woff2");
}

body {
  font-family: "UiSans", "Helvetica Neue", sans-serif;
}
```

```crystal
class FontStack < CSS::Stylesheet
  font_face UiSans, name: "UiSans" do
    src local("UiSans"), url("/assets/ui-sans.woff2")
  end

  rule body do
    font_family UiSans, "Helvetica Neue", :sans_serif
  end
end
```

## 6) Zebra table rows

```css
tbody tr:nth-of-type(odd) {
  background-color: #f8fafc;
}
```

```crystal
class ZebraRows < CSS::Stylesheet
  rule tbody > tr <= CSS::NthOfType.new(:odd) do
    background_color "#f8fafc"
  end
end
```

## CSS <-> Crystal translation hints

| CSS concept | Crystal DSL pattern |
| --- | --- |
| `property-name: value;` | `property_name value` |
| hyphenated property names | snake_case method names (`font-size` -> `font_size`) |
| `.class` selector | `css_class Name` then `rule Name do` |
| `#id` selector | `css_id Name` then `rule Name do` |
| child combinator (`a > b`) | `rule a > b do` |
| selector intersection (`.a.b` / `[attr]`) | `rule A && "[attr]" do` |
| pseudo syntax (`:hover`, `:before`) | `rule A <= :hover do` / `rule A <= :before do` |
| `@media (...)` | `media(...) do ... end` |
| CSS functions (`calc`, gradients, `rgb`) | `calc(...)`, `linear_gradient(...)`, `radial_gradient(...)`, `rgb(...)` |
| `!important` | `property ..., important: true` |
