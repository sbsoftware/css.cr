module CSS
  class NthOfType
    enum Static
      Odd
      Even

      def to_s(io : IO)
        io << self.to_s.underscore
      end
    end

    @exp : String | Int32 | Static

    def initialize(@exp); end

    def to_s(io : IO)
      io << "nth-of-type("
      io << @exp
      io << ")"
    end
  end
end
