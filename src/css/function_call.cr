module CSS
  abstract struct FunctionCall(T)
    abstract def function_name : String

    getter value : T

    def initialize(@value); end

    def to_s(io : IO)
      io << function_name
      io << "("
      io << value
      io << ")"
    end
  end
end
