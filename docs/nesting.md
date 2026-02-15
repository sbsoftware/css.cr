# Nesting

`rule` blocks can be nested. Nested rules compile to flattened descendant selectors.

```crystal
class NestedExample < CSS::Stylesheet
  rule article do
    padding 24.px

    rule h2 do
      margin_bottom 8.px

      rule span do
        font_weight :bold
      end
    end
  end
end
```

Output:

```css
article {
  padding: 24px;
}

article h2 {
  margin-bottom: 8px;
}

article h2 span {
  font-weight: bold;
}
```

## Multiple parent selectors

```crystal
class MultiParentNesting < CSS::Stylesheet
  rule section, aside do
    rule h3 do
      font_size 1.25.rem
    end
  end
end
```

Output:

```css
section h3, aside h3 {
  font-size: 1.25rem;
}
```
