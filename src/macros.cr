require "./css/class"
require "./css/element_id"

macro css_class(name)
  class {{name}} < CSS::Class; end
end

macro css_id(name)
  class {{name}} < CSS::ElementId; end
end
