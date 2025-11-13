module CSS
  abstract struct FunctionCall
    abstract def function_name : String
    abstract def arguments : String

    def to_s(io : IO)
      io << function_name
      io << "("
      io << arguments
      io << ")"
    end

    def to_css_value
      to_s
    end
  end
end
