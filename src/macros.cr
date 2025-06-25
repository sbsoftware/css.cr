require "./css/class"

macro css_class(name)
  class {{name}} < CSS::Class; end
end
