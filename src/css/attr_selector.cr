require "./selector"

module CSS
  class AttrSelector < Selector
    getter attr_name : String
    getter value : String?

    def initialize(@attr_name); end
    def initialize(@attr_name, @value); end

    def to_s(io : IO)
      io << "["
      io << attr_name
      if v = value
        io << "='"
        io << v
        io << "'"
      end
      io << "]"
    end
  end
end
