require "../stylesheet"

module CSS
  abstract class LayerStylesheet < CSS::Stylesheet
    module ClassMethods
      abstract def layer_name : String?
    end

    extend ClassMethods

    def self.format_layer_name(name : String) : String
      name
    end

    def self.format_layer_name(name : Symbol) : String
      name.to_s.gsub('_', '-')
    end

    macro inherited
      macro finished
        def self.to_s(io : IO)
          io << "@layer"
          if (name = layer_name)
            io << " "
            io << name
          end
          io << " {\n"
          previous_def
          io << "\n}"
        end
      end
    end

    macro rule(*selector_expressions, &blk)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        make_rule(io, { {% for selector_expression in selector_expressions %} make_selector({{selector_expression}}), {% end %} }, 1) {{blk}}
      end
    end

    macro embed(klass_name)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        %embedded = String.build do |%embedded_io|
          {{klass_name}}.to_s(%embedded_io)
        end

        write_indented(io, %embedded, 1)
      end
    end
  end
end
