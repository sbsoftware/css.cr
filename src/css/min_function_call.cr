module CSS
  # Represents a `min()` function call.
  struct MinFunctionCall
    getter arguments : String

    def initialize(*values)
      @arguments = build_arguments(values)
    end

    def to_s(io : IO)
      io << "min("
      io << arguments
      io << ")"
    end

    def to_css_value
      to_s
    end

    private def build_arguments(values : Tuple) : String
      values.map { |value| format(value) }.join(", ")
    end

    private def format(value) : String
      return value if value.is_a?(String)
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end
end
