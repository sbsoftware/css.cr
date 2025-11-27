require "./id_selector"

module CSS
  abstract class ElementId
    def self.to_s(io : IO)
      io << self.name.gsub("::", "--").underscore.gsub("_", "-")
    end

    def self.to_css_selector
      CSS::IdSelector.new(self.to_s)
    end
  end
end
