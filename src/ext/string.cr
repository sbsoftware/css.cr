require "../css/string_selector"

class String
  def to_css_selector
    CSS::StringSelector.new(self)
  end

  def to_css_value
    dump
  end
end
