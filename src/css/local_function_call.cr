require "./function_call"

module CSS
  struct LocalFunctionCall
    include FunctionCall
    getter name : String

    def initialize(@name)
    end

    def function_name : String
      "local"
    end

    def arguments : String
      name.dump
    end
  end
end
