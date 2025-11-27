require "./selector"

module CSS
  class IdSelector < Selector
    getter id_name : String

    def initialize(@id_name); end

    def to_s(io : IO)
      io << "#"
      io << id_name
    end
  end
end
