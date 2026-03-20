module CSS
  abstract class SupportsCondition
    def &(other : SupportsCondition) : SupportsCondition
      SupportsAndCondition.new(self, other)
    end

    def |(other : SupportsCondition) : SupportsCondition
      SupportsOrCondition.new(self, other)
    end

    def negate : SupportsCondition
      SupportsNotCondition.new(self)
    end

    def grouped : SupportsCondition
      SupportsGroupedCondition.new(self)
    end

    def needs_grouping? : Bool
      false
    end
  end

  class SupportsDeclarationCondition < SupportsCondition
    getter name : String
    getter value : String

    def initialize(name, value)
      @name = format_ident(name)
      @value = format_value(value)
    end

    def to_s(io : IO)
      io << "("
      io << name
      io << ": "
      io << value
      io << ")"
    end

    private def format_ident(value) : String
      return value.to_s.gsub('_', '-') if value.is_a?(Symbol)
      value.to_s
    end

    private def format_value(value) : String
      return value if value.is_a?(String)
      return value.to_s.gsub('_', '-') if value.is_a?(Symbol)
      return value.to_css_value.to_s if value.responds_to?(:to_css_value)

      value.to_s
    end
  end

  class SupportsSelectorCondition < SupportsCondition
    getter selector : String

    def initialize(@selector : String)
    end

    def to_s(io : IO)
      io << "selector("
      io << selector
      io << ")"
    end
  end

  class SupportsRawCondition < SupportsCondition
    getter value : String

    def initialize(@value : String)
    end

    def to_s(io : IO)
      io << value
    end
  end

  class SupportsAndCondition < SupportsCondition
    getter first : SupportsCondition
    getter second : SupportsCondition

    def initialize(@first : SupportsCondition, @second : SupportsCondition)
    end

    def needs_grouping? : Bool
      true
    end

    def to_s(io : IO)
      io << first
      io << " and "
      io << second
    end
  end

  class SupportsOrCondition < SupportsCondition
    getter first : SupportsCondition
    getter second : SupportsCondition

    def initialize(@first : SupportsCondition, @second : SupportsCondition)
    end

    def needs_grouping? : Bool
      true
    end

    def to_s(io : IO)
      io << first
      io << " or "
      io << second
    end
  end

  class SupportsNotCondition < SupportsCondition
    getter condition : SupportsCondition

    def initialize(@condition : SupportsCondition)
    end

    def needs_grouping? : Bool
      true
    end

    def to_s(io : IO)
      io << "not "
      if condition.needs_grouping?
        io << "("
        io << condition
        io << ")"
      else
        io << condition
      end
    end
  end

  class SupportsGroupedCondition < SupportsCondition
    getter condition : SupportsCondition

    def initialize(@condition : SupportsCondition)
    end

    def to_s(io : IO)
      io << "("
      io << condition
      io << ")"
    end
  end
end
