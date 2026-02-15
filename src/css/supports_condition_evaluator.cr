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

    # Readable alias for `decl`.
    def self.declaration(name, value) : CSS::SupportsCondition
      decl(name, value)
    end

    def self.selector(value : CSS::Selector) : CSS::SupportsCondition
      SupportsSelectorCondition.new(value.to_s)
    end

    def self.selector(value : String) : CSS::SupportsCondition
      SupportsSelectorCondition.new(value)
    end

    # Scoped alias to avoid ambiguity with selector-building helpers.
    def self.selector_condition(value : CSS::Selector) : CSS::SupportsCondition
      selector(value)
    end

    # Scoped alias to avoid ambiguity with selector-building helpers.
    def self.selector_condition(value : String) : CSS::SupportsCondition
      selector(value)
    end

    def self.raw(value : String) : CSS::SupportsCondition
      SupportsRawCondition.new(value)
    end

    def self.raw_condition(value : String) : CSS::SupportsCondition
      raw(value)
    end

    def self.group(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      SupportsGroupedCondition.new(condition)
    end

    def self.grouped(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      group(condition)
    end

    def self.negate(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      SupportsNotCondition.new(condition)
    end

    def self.not_condition(condition : CSS::SupportsCondition) : CSS::SupportsCondition
      negate(condition)
    end
  end
end
