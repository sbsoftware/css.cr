require "./css/local_function_call"
require "./css/url_function_call"

module CSS
  abstract class FontFace
    module ClassMethods
      abstract def font_name
    end

    extend ClassMethods

    macro inherited
      macro finished
        def self.to_s(io : IO)
          io << "@font-face {\n"
          io << "  font-family: "
          io << font_name.dump
          io << ";\n"
          previous_def
          io << "\n}"
        end
      end
    end

    def self.to_css_value
      font_name.dump
    end

    def self.src(*sources : LocalFunctionCall | UrlFunctionCall)
      "  src: #{sources.join(", ")};"
    end

    def self.local(value)
      LocalFunctionCall.new(value)
    end

    def self.url(value)
      UrlFunctionCall.new(value)
    end
  end
end
