require "./selector"

module CSS
  class DescendantSelector < Selector
    getter parent : Selector
    getter descendant : Selector

    def initialize(@parent, @descendant); end

    def to_s(io : IO)
      io << parent
      io << " "
      io << descendant
    end
  end
end
