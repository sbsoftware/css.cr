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

## Contributing

1. Fork it (<https://github.com/sbsoftware/css.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Stefan Bilharz](https://github.com/sbsoftware) - creator and maintainer
