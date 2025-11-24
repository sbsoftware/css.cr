require "./media_query"

module CSS
  class AndMediaQuery < MediaQuery
    getter first : MediaQuery
    getter second : MediaQuery

    def initialize(@first, @second)
    end

    def to_s(io : IO)
      io << first
      io << " and "
      io << second
    end
  end
end
