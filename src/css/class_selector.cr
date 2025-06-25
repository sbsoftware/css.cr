require "./selector"

module CSS
  class ClassSelector < Selector
    getter class_name : String

    def initialize(@class_name); end

    def to_s(io : IO)
      io << "."
      io << class_name
    end
  end
end
