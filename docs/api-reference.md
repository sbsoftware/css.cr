# API Reference Summary

This is a concise map of the public DSL surface. Use this file as the first stop before diving into source.

## Entry points

- `require "css"` from `src/css.cr`
- Subclass `CSS::Stylesheet` (`src/stylesheet.cr`)

## Core DSL macros/methods on `CSS::Stylesheet`

- Rule composition: `rule`, `embed`
- Media queries: `media`
- Properties: generated via `prop`, `prop2`, `prop3`, `prop4`, `prop5`, `prop6`
- CSS function/value helpers: `calc`, `min`, `minmax`, `repeat`, `fit_content`, `line_names`, `rgb`, `url`, `linear_gradient`, `radial_gradient`, `at`, `ratio`
- Font embedding: `font_face`
- Transform helper: `transform`
- Low-level escape hatch used by helpers: `property(name, value, important: false)`

## Selectors

- `rule div do ... end` for element selectors
- `css_class Name` and `css_id Name` macros (`src/macros.cr`)
- Operators used in selector expressions:
  - `>` child selector
  - `&&` selector combination
  - `<=` pseudoclass/pseudo-element targeting
- Selector model types live in `src/css/*selector*.cr`

## Units and calculations

- Numeric unit extensions in `src/units.cr` (for example: `.px`, `.rem`, `.percent`, `.deg`, `.fr`)
- Arithmetic on unit values produces typed values or `CSS::Calculation`
- `calc(...)` wraps calculations into CSS `calc(...)`

## Enums

- Enum DSL: `css_enum` macro in `src/css/css_enum.cr`
- Concrete enum files: `src/css/enums/*.cr`
- Symbol literals map to enum values in method calls (for example `display :inline_block`)

## Property API

- Property methods are defined in `src/stylesheet.cr`
- Method names mirror CSS property names in snake_case (`font_size`, `background_color`, `grid_template_columns`)
- Most methods support `important: true`

## Coverage and support status

- MDN coverage index: [`../COVERAGE.md`](../COVERAGE.md)
- Coverage generator script: `scripts/generate_coverage.cr`

## Keep this file current

When adding or changing public DSL APIs:

1. Update this summary if a new helper category or notable entrypoint is introduced.
2. Add/update specs in `spec/`.
3. Keep guide examples in `docs/` aligned with behavior.
