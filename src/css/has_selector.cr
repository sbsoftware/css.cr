require "./selector"

module CSS
  class HasSelector < Selector
    getter selector : Selector

    def initialize(@selector); end

    def to_s(io : IO)
      io << ":has("
      io << selector
      io << ")"
    end
  end
end
