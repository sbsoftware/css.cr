# Getting Started

## Install

1. Add `css` to `shard.yml`.
2. Run `shards install`.

## Define a stylesheet

```crystal
require "css"

class AppStyles < CSS::Stylesheet
  rule body do
    margin 0
    font_family "Inter", :sans_serif
  end

  rule h1 do
    font_size 2.rem
    margin_bottom 12.px
  end
end

puts AppStyles
```

Output:

```css
body {
  margin: 0;
  font-family: "Inter", sans-serif;
}

h1 {
  font-size: 2rem;
  margin-bottom: 12px;
}
```

## CSS <-> Crystal quick map

| CSS | Crystal DSL |
| --- | --- |
| `font-size: 16px;` | `font_size 16.px` |
| `margin-bottom: 12px;` | `margin_bottom 12.px` |
| `line-height: 1.5;` | `line_height 1.5` |
| `color: red;` | `color :red` |

## Next

- Continue with [Selectors](selectors.md) and [Nesting](nesting.md).
- For practical examples, jump to the [Cookbook](cookbook.md).
