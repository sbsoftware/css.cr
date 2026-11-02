require "./function_call"

module CSS
  class AnchorFunctionCall
    include FunctionCall

    def initialize(@name : CSS::AnchorName?, @side : CSS::Enums::AnchorSide | CSS::PercentValue, @fallback : CSS::LengthPercentage? = nil); end

    def function_name : String
      "anchor"
    end

    def arguments : String
      String.build do |io|
        if name = @name
          io << name << " "
        end
        io << @side.to_css_value
        if fallback = @fallback
          io << ", " << fallback.to_css_value
        end
      end
    end
  end
end
