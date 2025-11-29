require "../stylesheet"
require "./media_query_evaluator"

module CSS
  abstract class MediaStylesheet < CSS::Stylesheet
    module ClassMethods
      abstract def media_queries
    end

    extend ClassMethods

    macro inherited
      macro finished
        def self.to_s(io : IO)
          io << "@media "
          io << media_queries
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
  end
end
