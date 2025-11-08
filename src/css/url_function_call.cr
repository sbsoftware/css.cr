require "./function_call"

module CSS
  struct UrlFunctionCall < FunctionCall
    getter url : String

    def initialize(@url)
    end

    def function_name : String
      "url"
    end

    def arguments : String
      url.dump
    end
  end
end
