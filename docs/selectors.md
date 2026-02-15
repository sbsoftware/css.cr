# Selectors

## HTML tag selectors

```crystal
class BaseSelectors < CSS::Stylesheet
  rule main do
    display :block
  end

  rule button do
    cursor :pointer
  end
end
```

## Reusable class and id selectors

Define selector classes once and reuse them.

```crystal
css_class Card
css_id Header

class Components < CSS::Stylesheet
  rule Card do
    border_radius 12.px
  end

  rule Header do
    position :relative
  end
end
```

## Selector composition

```crystal
css_class Button

class AdvancedSelectors < CSS::Stylesheet
  # Child combinator
  rule nav > Button do
    margin_left 8.px
  end

  # Combine selectors
  rule Button && "[aria-pressed='true']" do
    font_weight :bold
  end

  # Pseudoclass/pseudo-element style syntax
  rule Button <= :hover do
    opacity 0.9
  end

  # nth-of-type helper
  rule li <= CSS::NthOfType.new(:odd) do
    background_color "#f8fafc"
  end
end
```

## CSS <-> Crystal translation hints

| CSS | Crystal DSL |
| --- | --- |
| `.card { ... }` | `css_class Card` + `rule Card do ... end` |
| `#header { ... }` | `css_id Header` + `rule Header do ... end` |
| `nav > .button { ... }` | `rule nav > Button do ... end` |
| `.button[aria-pressed='true'] { ... }` | `rule Button && "[aria-pressed='true']" do ... end` |
| `.button:hover { ... }` | `rule Button <= :hover do ... end` |
