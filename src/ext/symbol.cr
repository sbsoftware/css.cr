struct Symbol
  def to_css_value
    to_s.gsub('_', '-')
  end
end
