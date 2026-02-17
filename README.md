# css.cr

Create CSS stylesheets in pure Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     css:
       github: sbsoftware/css.cr
   ```

2. Run `shards install`.

## Quick Start

```crystal
require "css"

class Style < CSS::Stylesheet
  rule div do
    display :block
    padding 12.px
  end
end

puts Style
```

Output:

```css
div {
  display: block;
  padding: 12px;
}
```

## Documentation

Task-focused guides live in [`docs/`](docs/README.md):

- [Getting Started](docs/getting-started.md)
- [Selectors](docs/selectors.md)
- [Nesting](docs/nesting.md)
- [Media Queries](docs/media-queries.md)
- [Units and calc()](docs/units-and-calc.md)
- [Gradients and Colors](docs/gradients.md)
- [Fonts and @font-face](docs/fonts.md)
- [Using !important](docs/important.md)
- [Examples Gallery (copy/paste-ready DSL + rendered CSS)](examples/README.md)
- [Cookbook (idiomatic patterns + CSS <-> Crystal hints)](docs/cookbook.md)
- [API Reference Summary](docs/api-reference.md)
- [Contributor Guide: Adding Properties and Enums](docs/contributing-properties-and-enums.md)

## Coverage Index

Generate the MDN-vs-shard coverage index:

```bash
crystal scripts/generate_coverage.cr
```

The generated report is committed at [`COVERAGE.md`](COVERAGE.md) and includes:

- supported/unsupported/missing MDN property coverage,
- typed enum coverage for enum-applicable properties,
- unsupported string-only properties,
- a checklist for adding missing CSS.

## Contributing

Use the contributor docs in [`docs/contributing-properties-and-enums.md`](docs/contributing-properties-and-enums.md) for implementation details.

1. Fork it (<https://github.com/sbsoftware/css.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Stefan Bilharz](https://github.com/sbsoftware) - creator and maintainer
