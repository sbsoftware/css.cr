require "./single_media_query"

module CSS
  module MediaQueryEvaluator
    def self.evaluate(&)
      with self yield
    end

    def self.max_width(value : CSS::Length)
      CSS::SingleMediaQuery.new("max-width", value)
    end

    def self.min_width(value : CSS::Length)
      CSS::SingleMediaQuery.new("min-width", value)
    end

    def self.max_height(value : CSS::Length)
      CSS::SingleMediaQuery.new("max-height", value)
    end

    def self.min_height(value : CSS::Length)
      CSS::SingleMediaQuery.new("min-height", value)
    end

    def self.hover(value : CSS::Enums::HoverCapability)
      CSS::SingleMediaQuery.new("hover", value)
    end

    def self.any_hover(value : CSS::Enums::HoverCapability)
      CSS::SingleMediaQuery.new("any-hover", value)
    end
  end
end
