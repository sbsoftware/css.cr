require "./selector"

module CSS
  # This class is an intermediate object serving as a workaround to allow for
  # selector expressions like `a > b > c > d`.
  class NestedChildSelector < Selector
    getter child : Selector

    def initialize(@child); end

    def to_s(io : IO)
      raise "This method should not have been called (CSS::NestedChildSelector#to_s)"
    end
  end
end
