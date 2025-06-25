require "./selector"

module CSS
  class StringSelector < Selector
    getter string : String

    def initialize(@string); end

    def to_s(io : IO)
      io << string
    end
  end
end
