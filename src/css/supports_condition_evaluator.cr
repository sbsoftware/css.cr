require "./supports_condition"
require "./selector"

module CSS
  module SupportsConditionEvaluator
    def self.evaluate(&)
      with self yield
    end

    def self.decl(name, value) : CSS::SupportsCondition
      SupportsDeclarationCondition.new(name, value)
    end

    def self.selector(value : CSS::Selector) : CSS::SupportsCondition
      SupportsSelectorCondition.new(value.to_s)
    end

    def self.selector(value : String) : CSS::SupportsCondition
      SupportsSelectorCondition.new(value)
    end

    def self.raw(value : String) : CSS::SupportsCondition
      SupportsRawCondition.new(value)
    end

    def self.group(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      SupportsGroupedCondition.new(condition)
    end

    def self.negate(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      SupportsNotCondition.new(condition)
    end
  end
end
