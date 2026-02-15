# Sign-In Form

Form card styling with input controls, button treatment, and subtle elevation.

## Crystal DSL

```crystal
require "css"

class SignInFormExample < CSS::Stylesheet
  rule ".sign-in-form" do
    display :grid
    gap 12.px
    max_width 420.px
    padding 24.px
    border_radius 12.px
    background_color :white
    box_shadow 0.px, 10.px, 30.px, rgb(15, 23, 42, alpha: 10.percent)
  end

  rule ".sign-in-form input" do
    padding 10.px, 12.px
    border 1.px, :solid, "#cbd5e1"
    border_radius 8.px
    font_size 1.rem
  end

  rule ".sign-in-form button" do
    padding 10.px, 14.px
    border_radius 8.px
    border :none
    background_color "#2563eb"
    color :white
    font_weight :bold
  end
end

puts SignInFormExample
```

## Rendered CSS

```css
.sign-in-form {
  display: grid;
  gap: 12px;
  max-width: 420px;
  padding: 24px;
  border-radius: 12px;
  background-color: white;
  box-shadow: 0px 10px 30px rgb(15, 23, 42, 10%);
}

.sign-in-form input {
  padding: 10px 12px;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  font-size: 1rem;
}

.sign-in-form button {
  padding: 10px 14px;
  border-radius: 8px;
  border: none;
  background-color: #2563eb;
  color: white;
  font-weight: bold;
}
```
