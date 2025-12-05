require "./media_query"
require "./and_media_query"

module CSS
  class SingleMediaQuery(T) < MediaQuery
    getter name : String
    getter value : T

    def initialize(@name, @value)
    end

    def to_s(io : IO)
      io << "("
      io << name
      io << ": "
      io << value.to_css_value
      io << ")"
    end
  end
end
