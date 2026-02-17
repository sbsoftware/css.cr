# Editorial Typography

Readable article defaults with serif stack, vertical rhythm, and constrained line length.

## Crystal DSL

```crystal
require "css"

class EditorialTypographyExample < CSS::Stylesheet
  rule article do
    max_width 68.ch
    margin 0, :auto
    padding 32.px, 20.px
    font_family "Merriweather", "Georgia", :serif
    line_height 1.7
    color "#1f2937"

    rule h1 do
      font_size 2.5.rem
      line_height 1.2
      margin_bottom 16.px
    end

    rule p do
      margin_bottom 1.2.em
    end
  end
end

puts EditorialTypographyExample
```

## Rendered CSS

```css
article {
  max-width: 68ch;
  margin: 0 auto;
  padding: 32px 20px;
  font-family: "Merriweather", "Georgia", serif;
  line-height: 1.7;
  color: #1f2937;
}

article h1 {
  font-size: 2.5rem;
  line-height: 1.2;
  margin-bottom: 16px;
}

article p {
  margin-bottom: 1.2em;
}
```
