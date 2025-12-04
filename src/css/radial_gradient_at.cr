require "./function_call"

module CSS
  # Represents an `at <position>` clause for radial-gradient().
  # Accepts any position tokens (keywords, lengths, percentages) and renders
  # them space-separated after the `at` keyword.
  struct RadialGradientAt
    getter values : Array(String)

    def initialize(*values)
      @values = values.map(&.to_css_value).to_a
    end

    def to_css_value
      "at #{values.join(" ")}"
    end
  end
end
