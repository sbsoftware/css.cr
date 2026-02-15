# Fonts and @font-face

Use `font_face` to emit `@font-face` blocks and then reference the generated class in `font_family`.

```crystal
class Typography < CSS::Stylesheet
  font_face UiSans, name: "UiSans" do
    src local("UiSans"), url("/assets/ui-sans.woff2")
    font_weight :normal
  end

  rule body do
    font_family UiSans, "Helvetica Neue", :sans_serif
  end

  rule code do
    font_family :monospace
  end
end
```

Output:

```css
@font-face {
  font-family: "UiSans";
  src: local("UiSans"), url("/assets/ui-sans.woff2");
  font-weight: normal;
}

body {
  font-family: "UiSans", "Helvetica Neue", sans-serif;
}

code {
  font-family: monospace;
}
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `@font-face { font-family: "UiSans"; ... }` | `font_face UiSans, name: "UiSans" do ... end` |
| `font-family: "UiSans", sans-serif;` | `font_family UiSans, :sans_serif` |
