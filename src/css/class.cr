require "./class_selector"

module CSS
  abstract class Class
    def self.to_s(io : IO)
      io << self.name.gsub("::", "--").underscore.gsub("_", "-")
    end

    def self.to_css_selector
      CSS::ClassSelector.new(self.to_s)
    end
  end
end
