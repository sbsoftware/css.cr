require "./selector"

module CSS
  class CombinedSelector < Selector
    getter first : Selector
    getter second : Selector

    def initialize(@first, @second); end

    def to_s(io : IO)
      io << first
      io << second
    end
  end
end
