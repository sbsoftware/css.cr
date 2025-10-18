require "./function_call"

module CSS
  struct UrlFunctionCall < FunctionCall(String)
    def function_name : String
      "url"
    end

    def value
      super.dump
    end
  end
end
