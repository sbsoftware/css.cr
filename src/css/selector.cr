module CSS
  abstract class Selector
    def to_css_selector
      self
    end

    def combine(other_selector)
      CSS::CombinedSelector.new(self, other_selector)
    end
  end
end
