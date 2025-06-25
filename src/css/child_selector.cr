require "./selector"
require "./nested_child_selector"

module CSS
  class ChildSelector < Selector
    getter parent : Selector
    getter child : Selector

    def initialize(@parent, @child); end

    def combine(other_selector : CSS::NestedChildSelector)
      CSS::ChildSelector.new(self, other_selector.child)
    end

    def to_s(io : IO)
      io << parent
      io << " > "
      io << child
    end
  end
end
