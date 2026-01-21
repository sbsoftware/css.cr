require "./css/any_selector"
require "./css/string_selector"
require "./css/descendant_selector"
require "./css/child_selector"
require "./css/combined_selector"
require "./css/attr_selector"
require "./css/pseudoclass_selector"
require "./css/css_enum"
require "./css/enums/**"
require "./css/color_string"
require "./css/rgb_function_call"
require "./css/linear_gradient_direction"
require "./css/linear_gradient_function_call"
require "./css/radial_gradient_at"
require "./css/radial_gradient_function_call"
require "./css/min_function_call"
require "./css/url_function_call"
require "./css/transform_functions"
require "./css/transform_function_call"
require "./css/ratio"
require "./css/grid_template_columns"
require "./font_face"

module CSS
  class Stylesheet
    def self.calc(calculation : CSS::Calculation)
      CSS::CalcFunctionCall.new(calculation)
    end

    macro rule(*selector_expressions, &blk)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        make_rule(io, { {% for selector_expression in selector_expressions %} make_selector({{selector_expression}}), {% end %} }) {{blk}}
      end
    end

    macro make_selector(expr, nested = false)
      {% if expr.is_a?(Call) && expr.name == "any".id %}
        CSS::AnySelector.new
      {% elsif expr.is_a?(Call) && CSS::HTML_TAG_NAMES.includes?(expr.name.stringify) %}
        CSS::StringSelector.new({{expr.name.stringify}})
      {% elsif expr.is_a?(Call) && expr.name == "<=".id %}
        CSS::PseudoclassSelector.new(make_selector({{expr.receiver}}), {{expr.args.first.expressions.last}})
      {% elsif expr.is_a?(Call) && expr.name == "&&".id %}
        make_selector({{expr.receiver}}).combine(make_selector({{expr.args.first}}))
      {% elsif expr.is_a?(And) %}
        # This will occurr when multiple `>` calls are concatenated.
        # The Crystal compiler transforms `x > y > z` into `x > (__temp_136 = y) && __temp_136 > z`
        make_selector({{expr.left}}).combine(make_selector({{expr.right}}, true))
      {% elsif expr.is_a?(Assign) %}
        # This can occur via Crystal's internal transformations of `x > y > z`, for example
        make_selector({{expr.value}})
      {% elsif expr.is_a?(Call) && expr.name == ">".id %}
        {% if nested %}
          CSS::NestedChildSelector.new(make_selector({{expr.args.first}}))
        {% else %}
          CSS::ChildSelector.new(make_selector({{expr.receiver}}), make_selector({{expr.args.first}}))
        {% end %}
      {% elsif expr.is_a?(Expressions) %}
        make_selector({{expr.expressions.last}})
      {% else %}
        {{expr}}.to_css_selector
      {% end %}
    end

    macro make_rule(io, selectors, level = 0, &blk)
      %selectors = {{selectors}}
      %has_child_rules = false

      %child_rules = String.build do |%child_rule_io|
        {% if level > 0 %}
          {{io}} << "  " * {{level}}
        {% end %}
        %selectors.each_with_index do |%selector, %selector_index|
          {{io}} << ", " if %selector_index > 0
          {{io}} << %selector
        end
        {{io}} << " {\n"
        {% if blk.body.is_a?(Expressions) %}
          {% prop_exprs = blk.body.expressions.reject { |exp| exp.is_a?(Call) && exp.name.stringify == "rule" && exp.block } %}
          {% for exp, i in blk.body.expressions %}
            {% if exp.is_a?(Call) && exp.name.stringify == "rule" && exp.block %}
              %descendant_selectors = Array(CSS::Selector).new
              %selectors.each do |%selector|
                {% for arg in exp.args %}
                  %descendant_selectors << CSS::DescendantSelector.new(%selector, make_selector({{arg}}))
                {% end %}
              end
              %child_rule_io << "\n\n" if %has_child_rules
              make_rule(%child_rule_io, %descendant_selectors, {{level}}) {{exp.block}}
              %has_child_rules = true
            {% else %}
              {{io}} << "  " * {{level + 1}}
              {{io}} << {{exp}}
              {% if prop_exprs.size > 1 && i < prop_exprs.size - 1 %}
                {{io}} << "\n"
              {% end %}
            {% end %}
          {% end %}
        {% else %}
          {% if blk.body.is_a?(Call) && blk.body.name.stringify == "rule" && blk.body.block %}
            %descendant_selectors = Array(CSS::Selector).new
            %selectors.each do |%selector|
              {% for arg in blk.body.args %}
                %descendant_selectors << CSS::DescendantSelector.new(%selector, make_selector({{arg}}))
              {% end %}
            end
            %child_rule_io << "\n\n" if %has_child_rules
            make_rule(%child_rule_io, %descendant_selectors, {{level}}) {{blk.body.block}}
            %has_child_rules = true
          {% else %}
            {{io}} << "  " * {{level + 1}}
            {{io}} << {{blk.body}}
          {% end %}
        {% end %}
        {{io}} << "\n"
        {{io}} << "  " * {{level}}
        {{io}} << "}"
      end

      if %child_rules.size.positive?
        {{io}} << "\n\n"
        {{io}} << %child_rules
      end
    end

    macro prop(name, type, *, enforce_unit = true, transform_string = nil)
      macro {{name.id}}(value)
        {% if enforce_unit %}
          \{% if value.is_a?(NumberLiteral) && value != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value}})
      end

      def self._{{name.id}}(value : {{type}} | CSS::Enums::Global)
        %value = nil

        {% if transform_string %}
          if value.is_a?(String)
            %value = {{transform_string}}.new(value)
          end
        {% end %}
        %value ||= value

        property({{name.stringify}}, %value.to_css_value)
      end
    end

    macro prop2(name, type1, type2, *, enforce_unit1 = true, enforce_unit2 = true, transform_string1 = nil, transform_string2 = nil, separator = " ")
      macro {{name.id}}(value1, value2)
        {% if enforce_unit1 %}
          \{% if value1.is_a?(NumberLiteral) && value1 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value1}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit2 %}
          \{% if value2.is_a?(NumberLiteral) && value2 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value2}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value1}}, \{{value2}})
      end

      def self._{{name.id}}(value1 : {{type1}}, value2 : {{type2}})
        %value1 = %value2 = nil

        {% if transform_string1 %}
          if value1.is_a?(String)
            %value1 = {{transform_string1}}.new(value1)
          end
        {% end %}
        %value1 ||= value1

        {% if transform_string2 %}
          if value2.is_a?(String)
            %value2 = {{transform_string2}}.new(value2)
          end
        {% end %}
        %value2 ||= value2

        property({{name.stringify}}, "#{%value1.to_css_value}#{{{separator}}}#{%value2.to_css_value}")
      end
    end

    macro prop3(name, type1, type2, type3, *, enforce_unit1 = true, enforce_unit2 = true, enforce_unit3 = true, transform_string1 = nil, transform_string2 = nil, transform_string3 = nil, separator = " ")
      macro {{name.id}}(value1, value2, value3)
        {% if enforce_unit1 %}
          \{% if value1.is_a?(NumberLiteral) && value1 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value1}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit2 %}
          \{% if value2.is_a?(NumberLiteral) && value2 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value2}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit3 %}
          \{% if value3.is_a?(NumberLiteral) && value3 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value3}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value1}}, \{{value2}}, \{{value3}})
      end

      def self._{{name.id}}(value1 : {{type1}}, value2 : {{type2}}, value3 : {{type3}})
        %value1 = %value2 = %value3 = nil

        {% if transform_string1 %}
          if value1.is_a?(String)
            %value1 = {{transform_string1}}.new(value1)
          end
        {% end %}
        %value1 ||= value1

        {% if transform_string2 %}
          if value2.is_a?(String)
            %value2 = {{transform_string2}}.new(value2)
          end
        {% end %}
        %value2 ||= value2

        {% if transform_string3 %}
          if value3.is_a?(String)
            %value3 = {{transform_string3}}.new(value3)
          end
        {% end %}
        %value3 ||= value3

        property({{name.stringify}}, "#{%value1.to_css_value}#{{{separator}}}#{%value2.to_css_value}#{{{separator}}}#{%value3.to_css_value}")
      end
    end

    macro prop4(name, type1, type2, type3, type4, *, enforce_unit1 = true, enforce_unit2 = true, enforce_unit3 = true, enforce_unit4 = true, transform_string1 = nil, transform_string2 = nil, transform_string3 = nil, transform_string4 = nil, separator = " ")
      macro {{name.id}}(value1, value2, value3, value4)
        {% if enforce_unit1 %}
          \{% if value1.is_a?(NumberLiteral) && value1 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value1}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit2 %}
          \{% if value2.is_a?(NumberLiteral) && value2 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value2}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit3 %}
          \{% if value3.is_a?(NumberLiteral) && value3 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value3}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit4 %}
          \{% if value4.is_a?(NumberLiteral) && value4 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value4}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value1}}, \{{value2}}, \{{value3}}, \{{value4}})
      end

      def self._{{name.id}}(value1 : {{type1}}, value2 : {{type2}}, value3 : {{type3}}, value4 : {{type4}})
        %value1 = %value2 = %value3 = %value4 = nil

        {% if transform_string1 %}
          if value1.is_a?(String)
            %value1 = {{transform_string1}}.new(value1)
          end
        {% end %}
        %value1 ||= value1

        {% if transform_string2 %}
          if value2.is_a?(String)
            %value2 = {{transform_string2}}.new(value2)
          end
        {% end %}
        %value2 ||= value2

        {% if transform_string3 %}
          if value3.is_a?(String)
            %value3 = {{transform_string3}}.new(value3)
          end
        {% end %}
        %value3 ||= value3

        {% if transform_string4 %}
          if value4.is_a?(String)
            %value4 = {{transform_string4}}.new(value4)
          end
        {% end %}
        %value4 ||= value4

        property({{name.stringify}}, "#{%value1.to_css_value}#{{{separator}}}#{%value2.to_css_value}#{{{separator}}}#{%value3.to_css_value}#{{{separator}}}#{%value4.to_css_value}")
      end
    end

    macro prop5(name, type1, type2, type3, type4, type5, *, enforce_unit1 = true, enforce_unit2 = true, enforce_unit3 = true, enforce_unit4 = true, enforce_unit5 = true, transform_string1 = nil, transform_string2 = nil, transform_string3 = nil, transform_string4 = nil, transform_string5 = nil, separator = " ")
      macro {{name.id}}(value1, value2, value3, value4, value5)
        {% if enforce_unit1 %}
          \{% if value1.is_a?(NumberLiteral) && value1 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value1}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit2 %}
          \{% if value2.is_a?(NumberLiteral) && value2 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value2}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit3 %}
          \{% if value3.is_a?(NumberLiteral) && value3 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value3}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit4 %}
          \{% if value4.is_a?(NumberLiteral) && value4 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value4}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit5 %}
          \{% if value5.is_a?(NumberLiteral) && value5 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value5}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value1}}, \{{value2}}, \{{value3}}, \{{value4}}, \{{value5}})
      end

      def self._{{name.id}}(value1 : {{type1}}, value2 : {{type2}}, value3 : {{type3}}, value4 : {{type4}}, value5 : {{type5}})
        %value1 = %value2 = %value3 = %value4 = %value5 = nil

        {% if transform_string1 %}
          if value1.is_a?(String)
            %value1 = {{transform_string1}}.new(value1)
          end
        {% end %}
        %value1 ||= value1

        {% if transform_string2 %}
          if value2.is_a?(String)
            %value2 = {{transform_string2}}.new(value2)
          end
        {% end %}
        %value2 ||= value2

        {% if transform_string3 %}
          if value3.is_a?(String)
            %value3 = {{transform_string3}}.new(value3)
          end
        {% end %}
        %value3 ||= value3

        {% if transform_string4 %}
          if value4.is_a?(String)
            %value4 = {{transform_string4}}.new(value4)
          end
        {% end %}
        %value4 ||= value4

        {% if transform_string5 %}
          if value5.is_a?(String)
            %value5 = {{transform_string5}}.new(value5)
          end
        {% end %}
        %value5 ||= value5

        property({{name.stringify}}, "#{%value1.to_css_value}#{{{separator}}}#{%value2.to_css_value}#{{{separator}}}#{%value3.to_css_value}#{{{separator}}}#{%value4.to_css_value}#{{{separator}}}#{%value5.to_css_value}")
      end
    end

    macro prop6(name, type1, type2, type3, type4, type5, type6, *, enforce_unit1 = true, enforce_unit2 = true, enforce_unit3 = true, enforce_unit4 = true, enforce_unit5 = true, enforce_unit6 = true, transform_string1 = nil, transform_string2 = nil, transform_string3 = nil, transform_string4 = nil, transform_string5 = nil, transform_string6 = nil, separator = " ")
      macro {{name.id}}(value1, value2, value3, value4, value5, value6)
        {% if enforce_unit1 %}
          \{% if value1.is_a?(NumberLiteral) && value1 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value1}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit2 %}
          \{% if value2.is_a?(NumberLiteral) && value2 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value2}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit3 %}
          \{% if value3.is_a?(NumberLiteral) && value3 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value3}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit4 %}
          \{% if value4.is_a?(NumberLiteral) && value4 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value4}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit5 %}
          \{% if value5.is_a?(NumberLiteral) && value5 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value5}.px"}}
          \{% end %}
        {% end %}
        {% if enforce_unit6 %}
          \{% if value6.is_a?(NumberLiteral) && value6 != 0 %}
            \{{raise "Non-zero number values have to be specified with a unit, for example: #{value6}.px"}}
          \{% end %}
        {% end %}

        _{{name.id}}(\{{value1}}, \{{value2}}, \{{value3}}, \{{value4}}, \{{value5}}, \{{value6}})
      end

      def self._{{name.id}}(value1 : {{type1}}, value2 : {{type2}}, value3 : {{type3}}, value4 : {{type4}}, value5 : {{type5}}, value6 : {{type6}})
        %value1 = %value2 = %value3 = %value4 = %value5 = %value6 = nil

        {% if transform_string1 %}
          if value1.is_a?(String)
            %value1 = {{transform_string1}}.new(value1)
          end
        {% end %}
        %value1 ||= value1

        {% if transform_string2 %}
          if value2.is_a?(String)
            %value2 = {{transform_string2}}.new(value2)
          end
        {% end %}
        %value2 ||= value2

        {% if transform_string3 %}
          if value3.is_a?(String)
            %value3 = {{transform_string3}}.new(value3)
          end
        {% end %}
        %value3 ||= value3

        {% if transform_string4 %}
          if value4.is_a?(String)
            %value4 = {{transform_string4}}.new(value4)
          end
        {% end %}
        %value4 ||= value4

        {% if transform_string5 %}
          if value5.is_a?(String)
            %value5 = {{transform_string5}}.new(value5)
          end
        {% end %}
        %value5 ||= value5

        {% if transform_string6 %}
          if value6.is_a?(String)
            %value6 = {{transform_string6}}.new(value6)
          end
        {% end %}
        %value6 ||= value6

        property({{name.stringify}}, "#{%value1.to_css_value}#{{{separator}}}#{%value2.to_css_value}#{{{separator}}}#{%value3.to_css_value}#{{{separator}}}#{%value4.to_css_value}#{{{separator}}}#{%value5.to_css_value}#{{{separator}}}#{%value6.to_css_value}")
      end
    end

    def self.property(name, value)
      "#{name.gsub(/_/, "-")}: #{value};"
    end

    alias ImageFunction = CSS::UrlFunctionCall | CSS::LinearGradientFunctionCall | CSS::RadialGradientFunctionCall
    alias BackgroundTypes = Color | ImageFunction | CSS::Enums::VisualBox | CSS::Enums::BackgroundAttachment | CSS::Enums::BackgroundRepeat | CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter | CSS::Enums::Auto | CSS::LengthPercentage
    alias Color = CSS::Enums::CurrentColor | CSS::Enums::NamedColor | String | CSS::RgbFunctionCall
    alias BorderWidth = CSS::Length | CSS::Enums::BorderWidth
    alias OutlineWidth = BorderWidth
    alias BorderImageSource = ImageFunction | CSS::Enums::None
    alias BorderImageWidth = CSS::LengthPercentage | Int32 | Float32 | CSS::Enums::Auto
    alias BorderImageOutset = CSS::Length | Int32 | Float32
    alias BorderImage = BorderImageSource | CSS::NumberPercentage | CSS::Enums::BorderImageRepeat
    alias FontFamily = String | CSS::Enums::GenericFontFamily | CSS::FontFace.class
    alias TextDecoration = CSS::Enums::TextDecorationLine | CSS::Enums::SpellingError | CSS::Enums::GrammarError | CSS::Enums::TextDecorationStyle | CSS::Enums::FromFont | CSS::Enums::Auto | CSS::LengthPercentage | Color
    alias ListStyle = CSS::Enums::ListStyleType | String | CSS::Enums::ListStylePosition | ImageFunction
    alias AspectRatio = CSS::Ratio | CSS::RatioNumber | CSS::Enums::Auto
    alias TransformValue = CSS::TransformFunctionCall | CSS::Enums::None

    prop accent_color, String

    prop align_content, CSS::Enums::AlignContent | CSS::Enums::AlignContentPositional | CSS::Enums::AlignmentBaseline
    prop2 align_content, CSS::Enums::Safety, CSS::Enums::AlignContentPositional
    prop2 align_content, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline

    prop align_items, CSS::Enums::AlignItems | CSS::Enums::AlignItemsPositional | CSS::Enums::AlignmentBaseline
    prop2 align_items, CSS::Enums::Safety, CSS::Enums::AlignItemsPositional
    prop2 align_items, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline

    prop align_self, CSS::Enums::Auto | CSS::Enums::AlignItems | CSS::Enums::AlignItemsPositional | CSS::Enums::AlignmentBaseline
    prop2 align_self, CSS::Enums::Safety, CSS::Enums::AlignItemsPositional
    prop2 align_self, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline

    prop alignment_baseline, String
    prop all, String
    prop animation, String
    prop animation_composition, String
    prop animation_delay, String
    prop animation_direction, String
    prop animation_duration, String
    prop animation_fill_mode, String
    prop animation_iteration_count, Int | String
    prop animation_name, String
    prop animation_play_state, String
    prop animation_timing_function, String
    prop appearance, String
    prop aspect_ratio, AspectRatio, enforce_unit: false
    prop backdrop_filter, String
    prop backface_visibility, String

    prop background, BackgroundTypes, transform_string: CSS::ColorString
    prop2 background, BackgroundTypes, BackgroundTypes, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString
    prop3 background, BackgroundTypes, BackgroundTypes, BackgroundTypes, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString, transform_string3: CSS::ColorString
    prop4 background, BackgroundTypes, BackgroundTypes, BackgroundTypes, BackgroundTypes, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString, transform_string3: CSS::ColorString, transform_string4: CSS::ColorString

    prop background_attachment, CSS::Enums::BackgroundAttachment
    prop background_blend_mode, CSS::Enums::BlendMode
    prop background_clip, CSS::Enums::VisualBox | CSS::Enums::BackgroundClip
    prop background_color, Color, transform_string: CSS::ColorString
    prop background_image, ImageFunction
    prop background_origin, CSS::Enums::VisualBox

    prop background_position, CSS::LengthPercentage | CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter
    prop2 background_position, CSS::LengthPercentage | CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage | CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter
    prop2 background_position, CSS::LengthPercentage | CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage | CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter
    prop3 background_position, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter
    prop3 background_position, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage
    prop3 background_position, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter
    prop3 background_position, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage
    prop4 background_position, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage
    prop4 background_position, CSS::Enums::BackgroundPositionY | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage, CSS::Enums::BackgroundPositionX | CSS::Enums::BackgroundPositionCenter, CSS::LengthPercentage

    prop background_position_x, CSS::LengthPercentage | CSS::Enums::BackgroundPositionX
    prop background_position_y, CSS::LengthPercentage | CSS::Enums::BackgroundPositionY

    prop background_repeat, CSS::Enums::BackgroundRepeat
    prop2 background_repeat, CSS::Enums::BackgroundRepeat, CSS::Enums::BackgroundRepeat

    prop background_size, CSS::LengthPercentage | CSS::Enums::BackgroundSize | CSS::Enums::Auto
    prop2 background_size, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop baseline_shift, String
    prop block_size, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto

    prop border, Color, transform_string: CSS::ColorString
    prop border, BorderWidth
    prop border, CSS::Enums::LineStyle
    prop2 border, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border, BorderWidth, CSS::Enums::LineStyle
    prop2 border, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border, CSS::Enums::LineStyle, BorderWidth
    prop3 border, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_block, Color, transform_string: CSS::ColorString
    prop border_block, BorderWidth
    prop border_block, CSS::Enums::LineStyle
    prop2 border_block, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_block, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_block, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_block, BorderWidth, CSS::Enums::LineStyle
    prop2 border_block, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_block, CSS::Enums::LineStyle, BorderWidth
    prop3 border_block, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_block, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_block, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_block, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_block, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_block, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_block_color, Color, transform_string: CSS::ColorString
    prop2 border_block_color, Color, Color, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString

    prop border_block_end, Color, transform_string: CSS::ColorString
    prop border_block_end, BorderWidth
    prop border_block_end, CSS::Enums::LineStyle
    prop2 border_block_end, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_block_end, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_block_end, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_block_end, BorderWidth, CSS::Enums::LineStyle
    prop2 border_block_end, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_block_end, CSS::Enums::LineStyle, BorderWidth
    prop3 border_block_end, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_block_end, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_block_end, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_block_end, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_block_end, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_block_end, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_block_end_color, Color, transform_string: CSS::ColorString
    prop border_block_end_style, CSS::Enums::LineStyle
    prop border_block_end_width, BorderWidth

    prop border_block_start, Color, transform_string: CSS::ColorString
    prop border_block_start, BorderWidth
    prop border_block_start, CSS::Enums::LineStyle
    prop2 border_block_start, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_block_start, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_block_start, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_block_start, BorderWidth, CSS::Enums::LineStyle
    prop2 border_block_start, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_block_start, CSS::Enums::LineStyle, BorderWidth
    prop3 border_block_start, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_block_start, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_block_start, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_block_start, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_block_start, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_block_start, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_block_start_color, Color, transform_string: CSS::ColorString
    prop border_block_start_style, CSS::Enums::LineStyle
    prop border_block_start_width, BorderWidth

    prop border_block_style, CSS::Enums::LineStyle
    prop2 border_block_style, CSS::Enums::LineStyle, CSS::Enums::LineStyle

    prop border_block_width, BorderWidth
    prop2 border_block_width, BorderWidth, BorderWidth

    prop border_bottom, Color, transform_string: CSS::ColorString
    prop border_bottom, BorderWidth
    prop border_bottom, CSS::Enums::LineStyle
    prop2 border_bottom, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_bottom, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_bottom, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_bottom, BorderWidth, CSS::Enums::LineStyle
    prop2 border_bottom, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_bottom, CSS::Enums::LineStyle, BorderWidth
    prop3 border_bottom, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_bottom, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_bottom, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_bottom, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_bottom, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_bottom, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_bottom_color, Color, transform_string: CSS::ColorString

    prop border_bottom_left_radius, CSS::LengthPercentage
    prop2 border_bottom_left_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_bottom_right_radius, CSS::LengthPercentage
    prop2 border_bottom_right_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_bottom_style, CSS::Enums::LineStyle
    prop border_bottom_width, BorderWidth
    prop border_collapse, CSS::Enums::BorderCollapse

    prop border_color, Color, transform_string: CSS::ColorString
    prop2 border_color, Color, Color, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString
    prop3 border_color, Color, Color, Color, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString, transform_string3: CSS::ColorString
    prop4 border_color, Color, Color, Color, Color, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString, transform_string3: CSS::ColorString, transform_string4: CSS::ColorString

    prop border_end_end_radius, CSS::LengthPercentage
    prop2 border_end_end_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_end_start_radius, CSS::LengthPercentage
    prop2 border_end_start_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_image, BorderImage, enforce_unit: false
    prop2 border_image, BorderImage, BorderImage, enforce_unit1: false, enforce_unit2: false
    prop3 border_image, BorderImage, BorderImage, BorderImage, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false

    prop border_image_outset, BorderImageOutset, enforce_unit: false
    prop2 border_image_outset, BorderImageOutset, BorderImageOutset, enforce_unit1: false, enforce_unit2: false
    prop3 border_image_outset, BorderImageOutset, BorderImageOutset, BorderImageOutset, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false
    prop4 border_image_outset, BorderImageOutset, BorderImageOutset, BorderImageOutset, BorderImageOutset, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false

    prop border_image_repeat, CSS::Enums::BorderImageRepeat
    prop2 border_image_repeat, CSS::Enums::BorderImageRepeat, CSS::Enums::BorderImageRepeat

    prop border_image_slice, CSS::NumberPercentage, enforce_unit: false
    prop2 border_image_slice, CSS::NumberPercentage, CSS::Enums::Fill, enforce_unit1: false
    prop2 border_image_slice, CSS::Enums::Fill, CSS::NumberPercentage, enforce_unit2: false
    prop2 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit1: false, enforce_unit2: false
    prop3 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, CSS::Enums::Fill, enforce_unit1: false, enforce_unit2: false
    prop3 border_image_slice, CSS::Enums::Fill, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit2: false, enforce_unit3: false
    prop3 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false
    prop4 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, CSS::Enums::Fill, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false
    prop4 border_image_slice, CSS::Enums::Fill, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false
    prop4 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false
    prop5 border_image_slice, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, CSS::Enums::Fill, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false
    prop5 border_image_slice, CSS::Enums::Fill, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, CSS::NumberPercentage, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false, enforce_unit5: false

    prop border_image_source, BorderImageSource

    prop border_image_width, BorderImageWidth, enforce_unit: false
    prop2 border_image_width, BorderImageWidth, BorderImageWidth, enforce_unit1: false, enforce_unit2: false
    prop3 border_image_width, BorderImageWidth, BorderImageWidth, BorderImageWidth, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false
    prop4 border_image_width, BorderImageWidth, BorderImageWidth, BorderImageWidth, BorderImageWidth, enforce_unit1: false, enforce_unit2: false, enforce_unit3: false, enforce_unit4: false

    prop border_inline, Color, transform_string: CSS::ColorString
    prop border_inline, BorderWidth
    prop border_inline, CSS::Enums::LineStyle
    prop2 border_inline, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_inline, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_inline, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_inline, BorderWidth, CSS::Enums::LineStyle
    prop2 border_inline, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_inline, CSS::Enums::LineStyle, BorderWidth
    prop3 border_inline, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_inline, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_inline, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_inline, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_inline, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_inline, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_inline_color, Color, transform_string: CSS::ColorString
    prop2 border_inline_color, Color, Color, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString

    prop border_inline_end, Color, transform_string: CSS::ColorString
    prop border_inline_end, BorderWidth
    prop border_inline_end, CSS::Enums::LineStyle
    prop2 border_inline_end, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_inline_end, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_inline_end, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_inline_end, BorderWidth, CSS::Enums::LineStyle
    prop2 border_inline_end, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_inline_end, CSS::Enums::LineStyle, BorderWidth
    prop3 border_inline_end, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_inline_end, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_inline_end, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_inline_end, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_inline_end, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_inline_end, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_inline_end_color, Color, transform_string: CSS::ColorString
    prop border_inline_end_style, CSS::Enums::LineStyle
    prop border_inline_end_width, BorderWidth

    prop border_inline_start, Color, transform_string: CSS::ColorString
    prop border_inline_start, BorderWidth
    prop border_inline_start, CSS::Enums::LineStyle
    prop2 border_inline_start, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_inline_start, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_inline_start, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_inline_start, BorderWidth, CSS::Enums::LineStyle
    prop2 border_inline_start, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_inline_start, CSS::Enums::LineStyle, BorderWidth
    prop3 border_inline_start, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_inline_start, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_inline_start, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_inline_start, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_inline_start, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_inline_start, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_inline_start_color, Color, transform_string: CSS::ColorString
    prop border_inline_start_style, CSS::Enums::LineStyle
    prop border_inline_start_width, BorderWidth

    prop border_inline_style, CSS::Enums::LineStyle
    prop2 border_inline_style, CSS::Enums::LineStyle, CSS::Enums::LineStyle

    prop border_inline_width, BorderWidth
    prop2 border_inline_width, BorderWidth, BorderWidth

    prop border_left, Color, transform_string: CSS::ColorString
    prop border_left, BorderWidth
    prop border_left, CSS::Enums::LineStyle
    prop2 border_left, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_left, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_left, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_left, BorderWidth, CSS::Enums::LineStyle
    prop2 border_left, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_left, CSS::Enums::LineStyle, BorderWidth
    prop3 border_left, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_left, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_left, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_left, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_left, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_left, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_left_color, Color, transform_string: CSS::ColorString
    prop border_left_style, CSS::Enums::LineStyle
    prop border_left_width, BorderWidth

    prop border_radius, CSS::LengthPercentage
    prop2 border_radius, CSS::LengthPercentage, CSS::LengthPercentage
    prop3 border_radius, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage
    prop4 border_radius, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_right, Color, transform_string: CSS::ColorString
    prop border_right, BorderWidth
    prop border_right, CSS::Enums::LineStyle
    prop2 border_right, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_right, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_right, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_right, BorderWidth, CSS::Enums::LineStyle
    prop2 border_right, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_right, CSS::Enums::LineStyle, BorderWidth
    prop3 border_right, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_right, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_right, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_right, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_right, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_right, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_right_color, Color, transform_string: CSS::ColorString
    prop border_right_style, CSS::Enums::LineStyle
    prop border_right_width, BorderWidth

    prop border_spacing, CSS::Length
    prop2 border_spacing, CSS::Length, CSS::Length

    prop border_start_end_radius, CSS::LengthPercentage
    prop2 border_start_end_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_start_start_radius, CSS::LengthPercentage
    prop2 border_start_start_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_style, CSS::Enums::LineStyle
    prop2 border_style, CSS::Enums::LineStyle, CSS::Enums::LineStyle
    prop3 border_style, CSS::Enums::LineStyle, CSS::Enums::LineStyle, CSS::Enums::LineStyle
    prop4 border_style, CSS::Enums::LineStyle, CSS::Enums::LineStyle, CSS::Enums::LineStyle, CSS::Enums::LineStyle

    prop border_top, Color, transform_string: CSS::ColorString
    prop border_top, BorderWidth
    prop border_top, CSS::Enums::LineStyle
    prop2 border_top, Color, BorderWidth, transform_string1: CSS::ColorString
    prop2 border_top, Color, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop2 border_top, BorderWidth, Color, transform_string2: CSS::ColorString
    prop2 border_top, BorderWidth, CSS::Enums::LineStyle
    prop2 border_top, CSS::Enums::LineStyle, Color, transform_string2: CSS::ColorString
    prop2 border_top, CSS::Enums::LineStyle, BorderWidth
    prop3 border_top, Color, BorderWidth, CSS::Enums::LineStyle, transform_string1: CSS::ColorString
    prop3 border_top, Color, CSS::Enums::LineStyle, BorderWidth, transform_string1: CSS::ColorString
    prop3 border_top, BorderWidth, Color, CSS::Enums::LineStyle, transform_string2: CSS::ColorString
    prop3 border_top, BorderWidth, CSS::Enums::LineStyle, Color, transform_string3: CSS::ColorString
    prop3 border_top, CSS::Enums::LineStyle, Color, BorderWidth, transform_string2: CSS::ColorString
    prop3 border_top, CSS::Enums::LineStyle, BorderWidth, Color, transform_string3: CSS::ColorString

    prop border_top_color, Color, transform_string: CSS::ColorString

    prop border_top_left_radius, CSS::LengthPercentage
    prop2 border_top_left_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_top_right_radius, CSS::LengthPercentage
    prop2 border_top_right_radius, CSS::LengthPercentage, CSS::LengthPercentage

    prop border_top_style, CSS::Enums::LineStyle
    prop border_top_width, BorderWidth

    prop border_width, BorderWidth
    prop2 border_width, BorderWidth, BorderWidth
    prop3 border_width, BorderWidth, BorderWidth, BorderWidth
    prop4 border_width, BorderWidth, BorderWidth, BorderWidth, BorderWidth

    prop bottom, CSS::LengthPercentage | CSS::Enums::Auto
    prop box_decoration_break, String

    # No length
    prop box_shadow, CSS::Enums::None
    # 2 Lengths
    prop2 box_shadow, CSS::Length, CSS::Length
    prop3 box_shadow, Color, CSS::Length, CSS::Length, transform_string1: CSS::ColorString
    prop3 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length
    prop3 box_shadow, CSS::Length, CSS::Length, Color, transform_string3: CSS::ColorString
    prop3 box_shadow, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition
    prop4 box_shadow, Color, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition, transform_string1: CSS::ColorString
    prop4 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length, Color, transform_string4: CSS::ColorString
    # 3 Lengths
    prop3 box_shadow, CSS::Length, CSS::Length, CSS::Length
    prop4 box_shadow, Color, CSS::Length, CSS::Length, CSS::Length, transform_string1: CSS::ColorString
    prop4 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length, CSS::Length
    prop4 box_shadow, CSS::Length, CSS::Length, CSS::Length, Color, transform_string4: CSS::ColorString
    prop4 box_shadow, CSS::Length, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition
    prop5 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length, CSS::Length, Color, transform_string5: CSS::ColorString
    prop5 box_shadow, Color, CSS::Length, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition, transform_string1: CSS::ColorString
    # 4 Lengths
    prop4 box_shadow, CSS::Length, CSS::Length, CSS::Length, CSS::Length
    prop5 box_shadow, Color, CSS::Length, CSS::Length, CSS::Length, CSS::Length, transform_string1: CSS::ColorString
    prop5 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length, CSS::Length, CSS::Length
    prop5 box_shadow, CSS::Length, CSS::Length, CSS::Length, CSS::Length, Color, transform_string5: CSS::ColorString
    prop5 box_shadow, CSS::Length, CSS::Length, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition
    prop6 box_shadow, CSS::Enums::BoxShadowPosition, CSS::Length, CSS::Length, CSS::Length, CSS::Length, Color, transform_string5: CSS::ColorString
    prop6 box_shadow, Color, CSS::Length, CSS::Length, CSS::Length, CSS::Length, CSS::Enums::BoxShadowPosition, transform_string1: CSS::ColorString

    prop box_sizing, CSS::Enums::BoxSizing
    prop break_after, String
    prop break_before, String
    prop break_inside, String
    prop caption_side, String
    prop caret, String
    prop caret_color, String
    prop caret_shape, String
    prop clear, CSS::Enums::Clear
    prop clip_path, String
    prop clip_rule, String
    prop color, Color, transform_string: CSS::ColorString
    prop color_interpolation_filters, String
    prop color_scheme, String
    prop column_count, Int
    prop column_fill, String
    prop column_gap, CSS::Enums::Gap | CSS::LengthPercentage
    prop column_rule, String
    prop column_rule_color, String
    prop column_rule_style, String
    prop column_rule_width, CSS::LengthPercentage
    prop column_span, String
    prop column_width, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop columns, String
    prop contain, String
    prop contain_intrinsic_block_size, String
    prop contain_intrinsic_height, String
    prop contain_intrinsic_inline_size, String
    prop contain_intrinsic_size, String
    prop contain_intrinsic_width, String
    prop container, String
    prop container_name, String
    prop container_type, String
    prop content, String
    prop content_visibility, String
    prop counter_increment, Int | String
    prop counter_reset, Int | String
    prop counter_set, String
    prop cursor, CSS::Enums::Cursor
    prop cx, String
    prop cy, String
    prop d, String
    prop direction, String
    prop display, CSS::Enums::Display
    prop dominant_baseline, String
    prop empty_cells, String
    prop fill, String
    prop fill_opacity, String
    prop fill_rule, String
    prop filter, String
    prop flex, CSS::Enums::Flex # keyword or global value
    prop flex, Number, enforce_unit: false # flex-grow only
    prop flex, CSS::LengthPercentage | CSS::Enums::FlexBasis | CSS::Enums::Auto # flex-basis only
    prop2 flex, Number, CSS::LengthPercentage | CSS::Enums::FlexBasis | CSS::Enums::Auto, enforce_unit1: false # flex-grow and flex-basis
    prop2 flex, Number, Number, enforce_unit1: false, enforce_unit2: false # flex-grow and flex-shrink
    prop3 flex, Number, Number, CSS::LengthPercentage | CSS::Enums::FlexBasis | CSS::Enums::Auto, enforce_unit1: false, enforce_unit2: false # flex-grow, flex-shrink and flex-basis
    prop flex_basis, CSS::LengthPercentage | CSS::Enums::FlexBasis | CSS::Enums::Auto
    prop flex_direction, CSS::Enums::FlexDirection
    prop flex_flow, CSS::Enums::FlexDirection | CSS::Enums::FlexWrap
    prop2 flex_flow, CSS::Enums::FlexDirection, CSS::Enums::FlexWrap
    prop flex_grow, Number, enforce_unit: false
    prop flex_shrink, Number, enforce_unit: false
    prop flex_wrap, CSS::Enums::FlexWrap
    prop float, CSS::Enums::Float
    prop flood_color, String
    prop flood_opacity, String
    prop font, String

    prop font_family, FontFamily
    prop2 font_family, FontFamily, FontFamily, separator: ", "
    prop3 font_family, FontFamily, FontFamily, FontFamily, separator: ", "
    prop4 font_family, FontFamily, FontFamily, FontFamily, FontFamily, separator: ", "
    prop5 font_family, FontFamily, FontFamily, FontFamily, FontFamily, FontFamily, separator: ", "
    prop6 font_family, FontFamily, FontFamily, FontFamily, FontFamily, FontFamily, FontFamily, separator: ", "

    prop font_feature_settings, String
    prop font_kerning, CSS::Enums::FontKerning
    prop font_language_override, String
    prop font_optical_sizing, CSS::Enums::Auto | CSS::Enums::None
    prop font_palette, String
    prop font_size, CSS::Enums::RelativeSize | CSS::Enums::AbsoluteSize | CSS::LengthPercentage | CSS::Enums::Math

    prop font_size_adjust, CSS::Enums::None | CSS::Enums::FromFont | Int32 | Float32, enforce_unit: false
    prop2 font_size_adjust, CSS::Enums::FontMetric, CSS::Enums::FromFont | Int32 | Float32, enforce_unit2: false

    prop font_style, CSS::Enums::FontStyle | CSS::Enums::Oblique
    prop2 font_style, CSS::Enums::Oblique, CSS::DegValue

    prop font_synthesis, CSS::Enums::None | CSS::Enums::FontSynthesis
    prop2 font_synthesis, CSS::Enums::FontSynthesis, CSS::Enums::FontSynthesis
    prop3 font_synthesis, CSS::Enums::FontSynthesis, CSS::Enums::FontSynthesis, CSS::Enums::FontSynthesis

    prop font_synthesis_small_caps, CSS::Enums::Auto | CSS::Enums::None
    prop font_synthesis_style, CSS::Enums::Auto | CSS::Enums::None
    prop font_synthesis_weight, CSS::Enums::Auto | CSS::Enums::None
    prop font_variant, String
    prop font_variant_alternates, String
    prop font_variant_caps, CSS::Enums::FontVariantCaps
    prop font_variant_east_asian, String
    prop font_variant_emoji, String
    prop font_variant_ligatures, String
    prop font_variant_numeric, String
    prop font_variant_position, String

    prop font_variation_settings, CSS::Enums::FontVariationSettings
    prop2 font_variation_settings, String, Number, enforce_unit2: false

    prop font_weight, Int32 | Float64 | CSS::Enums::FontWeight, enforce_unit: false
    prop forced_color_adjust, String
    prop gap, CSS::Enums::Gap | CSS::LengthPercentage
    prop2 gap, CSS::Enums::Gap | CSS::LengthPercentage, CSS::Enums::Gap | CSS::LengthPercentage
    prop grid, String
    prop grid_area, String
    prop grid_auto_columns, String
    prop grid_auto_flow, String
    prop grid_auto_rows, String
    prop grid_column, Int
    prop grid_column_end, Int
    prop grid_column_start, Int
    prop grid_row, Int
    prop grid_row_end, Int
    prop grid_row_start, Int
    prop grid_template, String
    prop grid_template_areas, String

    macro grid_template_rows(*values)
      {% if values.empty? %}
        {{ raise "grid_template_rows requires at least one value" }}
      {% end %}

      {% for value in values %}
        {% if value.is_a?(NumberLiteral) && value != 0 %}
          {{ value.raise "Non-zero number values have to be specified with a unit, for example: #{value}.px" }}
        {% end %}
      {% end %}

      _grid_template_rows({{values.splat}})
    end

    def self._grid_template_rows(value : CSS::Enums::None | CSS::Enums::Masonry | CSS::Enums::Global)
      property("grid-template-rows", value.to_css_value)
    end

    def self._grid_template_rows(value : CSS::Enums::Subgrid, *names : CSS::GridLineNameListItem)
      if names.empty?
        property("grid-template-rows", value.to_css_value)
      else
        property("grid-template-rows", "#{value.to_css_value} #{names.map(&.to_css_value).join(" ")}")
      end
    end

    def self._grid_template_rows(*values : CSS::GridTrackListValue)
      property("grid-template-rows", values.map(&.to_css_value).join(" "))
    end

    macro grid_template_columns(*values)
      {% if values.empty? %}
        {{ raise "grid_template_columns requires at least one value" }}
      {% end %}

      {% for value in values %}
        {% if value.is_a?(NumberLiteral) && value != 0 %}
          {{ value.raise "Non-zero number values have to be specified with a unit, for example: #{value}.px" }}
        {% end %}
      {% end %}

      _grid_template_columns({{values.splat}})
    end

    def self._grid_template_columns(value : CSS::Enums::None | CSS::Enums::Masonry | CSS::Enums::Global)
      property("grid-template-columns", value.to_css_value)
    end

    def self._grid_template_columns(value : CSS::Enums::Subgrid, *names : CSS::GridLineNameListItem)
      if names.empty?
        property("grid-template-columns", value.to_css_value)
      else
        property("grid-template-columns", "#{value.to_css_value} #{names.map(&.to_css_value).join(" ")}")
      end
    end

    def self._grid_template_columns(*values : CSS::GridTrackListValue)
      property("grid-template-columns", values.map(&.to_css_value).join(" "))
    end

    prop hanging_punctuation, String
    prop height, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop hyphenate_character, String
    prop hyphenate_limit_chars, String
    prop hyphens, CSS::Enums::Hyphens
    prop image_orientation, String
    prop image_rendering, String
    prop initial_letter, String
    prop inline_size, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto

    prop inset, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 inset, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto
    prop3 inset, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto
    prop4 inset, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop inset_block, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 inset_block, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop inset_block_end, CSS::LengthPercentage | CSS::Enums::Auto
    prop inset_block_start, CSS::LengthPercentage | CSS::Enums::Auto

    prop inset_inline, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 inset_inline, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop inset_inline_end, CSS::LengthPercentage | CSS::Enums::Auto
    prop inset_inline_start, CSS::LengthPercentage | CSS::Enums::Auto
    prop isolation, String
    prop justify_content, CSS::Enums::JustifyContent | CSS::Enums::JustifyContentPositional
    prop2 justify_content, CSS::Enums::Safety, CSS::Enums::JustifyContentPositional
    prop justify_items, CSS::Enums::JustifyItems | CSS::Enums::JustifyItemsPositional | CSS::Enums::AlignmentBaseline | CSS::Enums::JustifyItemsLegacy
    prop2 justify_items, CSS::Enums::Safety, CSS::Enums::JustifyItemsPositional
    prop2 justify_items, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline
    prop2 justify_items, CSS::Enums::JustifyItemsLegacy, CSS::Enums::JustifyItemsLegacyPositional
    prop justify_self, String
    prop left, CSS::LengthPercentage | CSS::Enums::Auto
    prop letter_spacing, String
    prop lighting_color, String
    prop line_break, String
    prop line_clamp, Int | String
    prop line_height, CSS::Enums::LineHeight | Int32 | Float64 | CSS::LengthPercentage, enforce_unit: false

    prop list_style, ListStyle
    prop2 list_style, ListStyle, ListStyle
    prop3 list_style, ListStyle, ListStyle, ListStyle

    prop list_style_image, ImageFunction | CSS::Enums::None
    prop list_style_position, CSS::Enums::ListStylePosition
    prop list_style_type, CSS::Enums::ListStyleType | String

    prop margin, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 margin, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto
    prop3 margin, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto
    prop4 margin, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop margin_block, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 margin_block, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop margin_block_end, CSS::LengthPercentage | CSS::Enums::Auto
    prop margin_block_start, CSS::LengthPercentage | CSS::Enums::Auto

    prop margin_bottom, CSS::LengthPercentage | CSS::Enums::Auto

    prop margin_inline, CSS::LengthPercentage | CSS::Enums::Auto
    prop2 margin_inline, CSS::LengthPercentage | CSS::Enums::Auto, CSS::LengthPercentage | CSS::Enums::Auto

    prop margin_inline_end, CSS::LengthPercentage | CSS::Enums::Auto
    prop margin_inline_start, CSS::LengthPercentage | CSS::Enums::Auto
    prop margin_left, CSS::LengthPercentage | CSS::Enums::Auto
    prop margin_right, CSS::LengthPercentage | CSS::Enums::Auto
    prop margin_top, CSS::LengthPercentage | CSS::Enums::Auto

    prop marker, String
    prop marker_end, String
    prop marker_mid, String
    prop marker_start, String
    prop mask, String
    prop mask_border, String
    prop mask_border_mode, String
    prop mask_border_outset, String
    prop mask_border_repeat, String
    prop mask_border_slice, String
    prop mask_border_source, String
    prop mask_border_width, String
    prop mask_clip, String
    prop mask_composite, String
    prop mask_image, String
    prop mask_mode, String
    prop mask_origin, String
    prop mask_position, String
    prop mask_repeat, String
    prop mask_size, String
    prop mask_type, String
    prop math_depth, String
    prop math_style, String
    prop max_block_size, CSS::LengthPercentage | CSS::Enums::Size
    prop max_height, CSS::LengthPercentage | CSS::Enums::Size
    prop max_inline_size, CSS::LengthPercentage | CSS::Enums::Size
    prop max_width, CSS::LengthPercentage | CSS::Enums::Size
    prop min_block_size, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop min_height, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop min_inline_size, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop min_width, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop mix_blend_mode, String
    prop object_fit, String
    prop object_position, String
    prop offset, String
    prop offset_anchor, String
    prop offset_distance, String
    prop offset_path, String
    prop offset_position, String
    prop offset_rotate, String
    prop opacity, Number | CSS::PercentValue, enforce_unit: false
    prop order, Int, enforce_unit: false
    prop orphans, Int
    prop outline, Color, transform_string: CSS::ColorString
    prop outline, OutlineWidth
    prop outline, CSS::Enums::OutlineStyle
    prop2 outline, Color, OutlineWidth, transform_string1: CSS::ColorString
    prop2 outline, Color, CSS::Enums::OutlineStyle, transform_string1: CSS::ColorString
    prop2 outline, OutlineWidth, Color, transform_string2: CSS::ColorString
    prop2 outline, OutlineWidth, CSS::Enums::OutlineStyle
    prop2 outline, CSS::Enums::OutlineStyle, Color, transform_string2: CSS::ColorString
    prop2 outline, CSS::Enums::OutlineStyle, OutlineWidth
    prop3 outline, Color, OutlineWidth, CSS::Enums::OutlineStyle, transform_string1: CSS::ColorString
    prop3 outline, Color, CSS::Enums::OutlineStyle, OutlineWidth, transform_string1: CSS::ColorString
    prop3 outline, OutlineWidth, Color, CSS::Enums::OutlineStyle, transform_string2: CSS::ColorString
    prop3 outline, OutlineWidth, CSS::Enums::OutlineStyle, Color, transform_string3: CSS::ColorString
    prop3 outline, CSS::Enums::OutlineStyle, Color, OutlineWidth, transform_string2: CSS::ColorString
    prop3 outline, CSS::Enums::OutlineStyle, OutlineWidth, Color, transform_string3: CSS::ColorString

    prop outline_color, Color, transform_string: CSS::ColorString
    prop outline_offset, CSS::Length
    prop outline_style, CSS::Enums::OutlineStyle
    prop outline_width, OutlineWidth

    prop overflow, CSS::Enums::Overflow
    prop2 overflow, CSS::Enums::Overflow, CSS::Enums::Overflow

    prop overflow_anchor, CSS::Enums::OverflowAnchor
    prop overflow_block, CSS::Enums::Overflow

    prop overflow_clip_margin, CSS::Length
    prop overflow_clip_margin, CSS::Enums::VisualBox
    prop2 overflow_clip_margin, CSS::Enums::VisualBox, CSS::Length
    prop2 overflow_clip_margin, CSS::Length, CSS::Enums::VisualBox

    prop overflow_inline, CSS::Enums::Overflow
    prop overflow_wrap, CSS::Enums::OverflowWrap
    prop overflow_x, CSS::Enums::Overflow
    prop overflow_y, CSS::Enums::Overflow
    prop overscroll_behavior, CSS::Enums::OverscrollBehavior
    prop2 overscroll_behavior, CSS::Enums::OverscrollBehavior, CSS::Enums::OverscrollBehavior
    prop overscroll_behavior_block, CSS::Enums::OverscrollBehavior
    prop overscroll_behavior_inline, CSS::Enums::OverscrollBehavior
    prop overscroll_behavior_x, CSS::Enums::OverscrollBehavior
    prop overscroll_behavior_y, CSS::Enums::OverscrollBehavior

    prop padding, CSS::LengthPercentage
    prop2 padding, CSS::LengthPercentage, CSS::LengthPercentage
    prop3 padding, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage
    prop4 padding, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage, CSS::LengthPercentage

    prop padding_block, CSS::LengthPercentage
    prop2 padding_block, CSS::LengthPercentage, CSS::LengthPercentage

    prop padding_block_end, CSS::LengthPercentage
    prop padding_block_start, CSS::LengthPercentage

    prop padding_bottom, CSS::LengthPercentage

    prop padding_inline, CSS::LengthPercentage
    prop2 padding_inline, CSS::LengthPercentage, CSS::LengthPercentage

    prop padding_inline_end, CSS::LengthPercentage
    prop padding_inline_start, CSS::LengthPercentage
    prop padding_left, CSS::LengthPercentage
    prop padding_right, CSS::LengthPercentage
    prop padding_top, CSS::LengthPercentage

    prop page, String
    prop paint_order, String
    prop perspective, String
    prop perspective_origin, String
    prop place_content, String
    prop place_items, String
    prop place_self, String
    prop pointer_events, CSS::Enums::PointerEvents
    prop position, CSS::Enums::Position
    prop print_color_adjust, String
    prop quotes, String
    prop r, String
    prop resize, String
    prop right, CSS::LengthPercentage | CSS::Enums::Auto
    prop rotate, String
    prop row_gap, CSS::Enums::Gap | CSS::LengthPercentage
    prop ruby_align, String
    prop ruby_overhang, String
    prop ruby_position, String
    prop rx, String
    prop ry, String
    prop scale, String
    prop scroll_behavior, String
    prop scroll_margin, String
    prop scroll_margin_block, String
    prop scroll_margin_block_end, String
    prop scroll_margin_block_start, String
    prop scroll_margin_bottom, String
    prop scroll_margin_inline, String
    prop scroll_margin_inline_end, String
    prop scroll_margin_inline_start, String
    prop scroll_margin_left, String
    prop scroll_margin_right, String
    prop scroll_margin_top, String
    prop scroll_padding, String
    prop scroll_padding_block, String
    prop scroll_padding_block_end, String
    prop scroll_padding_block_start, String
    prop scroll_padding_bottom, String
    prop scroll_padding_inline, String
    prop scroll_padding_inline_end, String
    prop scroll_padding_inline_start, String
    prop scroll_padding_left, String
    prop scroll_padding_right, String
    prop scroll_padding_top, String
    prop scroll_snap_align, String
    prop scroll_snap_stop, String
    prop scroll_snap_type, String
    prop scrollbar_color, String
    prop scrollbar_gutter, String
    prop scrollbar_width, String
    prop shape_image_threshold, String
    prop shape_margin, String
    prop shape_outside, String
    prop shape_rendering, String
    prop stop_color, String
    prop stop_opacity, String
    prop stroke, String
    prop stroke_dasharray, String
    prop stroke_dashoffset, String
    prop stroke_linecap, String
    prop stroke_linejoin, String
    prop stroke_miterlimit, String
    prop stroke_opacity, String
    prop stroke_width, String
    prop tab_size, Int
    prop table_layout, String

    prop _webkit_tap_highlight_color, Color, transform_string: CSS::ColorString

    prop text_align, CSS::Enums::TextAlign | String
    prop2 text_align, String, CSS::Enums::TextAlign

    prop text_align_last, CSS::Enums::TextAlignLast
    prop text_anchor, String
    prop text_box, String
    prop text_box_edge, String
    prop text_box_trim, String
    prop text_combine_upright, String

    prop text_decoration, CSS::Enums::None | TextDecoration, transform_string: CSS::ColorString
    prop2 text_decoration, TextDecoration, TextDecoration, transform_string1: CSS::ColorString, transform_string2: CSS::ColorString
    prop3 text_decoration, TextDecoration, TextDecoration, TextDecoration
    prop4 text_decoration, TextDecoration, TextDecoration, TextDecoration, TextDecoration

    prop text_decoration_color, Color, transform_string: CSS::ColorString

    prop text_decoration_line, CSS::Enums::None | CSS::Enums::TextDecorationLine | CSS::Enums::SpellingError | CSS::Enums::GrammarError
    prop2 text_decoration_line, CSS::Enums::TextDecorationLine, CSS::Enums::TextDecorationLine
    prop3 text_decoration_line, CSS::Enums::TextDecorationLine, CSS::Enums::TextDecorationLine, CSS::Enums::TextDecorationLine

    prop text_decoration_skip_ink, CSS::Enums::TextDecorationSkipInk
    prop text_decoration_style, CSS::Enums::TextDecorationStyle
    prop text_decoration_thickness, CSS::Enums::FromFont | CSS::Enums::Auto | CSS::LengthPercentage
    prop text_emphasis, String
    prop text_emphasis_color, String
    prop text_emphasis_position, String
    prop text_emphasis_style, String
    prop text_indent, String
    prop text_justify, String
    prop text_orientation, String
    prop text_overflow, CSS::Enums::TextOverflow | String
    prop2 text_overflow, CSS::Enums::TextOverflow | String, CSS::Enums::TextOverflow | String
    prop text_rendering, String
    prop text_shadow, String
    prop text_transform, String
    prop text_underline_offset, String
    prop text_underline_position, String
    prop text_wrap, String
    prop text_wrap_mode, String
    prop text_wrap_style, String
    prop top, CSS::LengthPercentage | CSS::Enums::Auto
    prop touch_action, String
    prop transform_box, String
    prop transform_origin, String
    prop transform_style, String
    prop transition, String
    prop transition_behavior, String
    prop transition_delay, String
    prop transition_duration, String
    prop transition_property, String
    prop transition_timing_function, String
    prop translate, String
    prop unicode_bidi, String
    prop user_select, CSS::Enums::UserSelect
    prop vector_effect, String
    prop vertical_align, CSS::LengthPercentage | CSS::Enums::VerticalAlign
    prop view_transition_class, String
    prop view_transition_name, String
    prop visibility, String
    prop white_space, CSS::Enums::WhiteSpace
    prop white_space_collapse, String
    prop widows, Int
    prop width, CSS::LengthPercentage | CSS::Enums::Size | CSS::Enums::Auto
    prop will_change, String
    prop word_break, String
    prop word_spacing, String
    prop word_wrap, CSS::Enums::OverflowWrap
    prop writing_mode, String
    prop x, String
    prop y, String
    prop z_index, Int, enforce_unit: false
    prop zoom, String

    def self.ratio(numerator, denominator = nil)
      Ratio.new(numerator, denominator)
    end

    macro min(*values)
      {% if values.size < 2 %}
        {{ raise "min requires at least two values" }}
      {% end %}

      {% for value in values %}
        {% if value.is_a?(NumberLiteral) && value != 0 %}
          {{ value.raise "Non-zero number values have to be specified with a unit, for example: #{value}.px" }}
        {% end %}
      {% end %}

      _min({{values.splat}})
    end

    def self._min(*values : CSS::GridLengthPercentage)
      CSS::MinFunctionCall.new(*values)
    end

    def self.line_names(*names : CSS::GridLineName)
      CSS::GridLineNames.new(*names)
    end

    macro fit_content(value)
      {% if value.is_a?(NumberLiteral) && value != 0 %}
        {{ value.raise "Non-zero number values have to be specified with a unit, for example: #{value}.px" }}
      {% end %}

      _fit_content({{value}})
    end

    def self._fit_content(value : CSS::GridLengthPercentage)
      CSS::GridFitContentFunctionCall.new(value)
    end

    macro minmax(min, max)
      {% if min.is_a?(NumberLiteral) && min != 0 %}
        {{ min.raise "Non-zero number values have to be specified with a unit, for example: #{min}.px" }}
      {% end %}
      {% if max.is_a?(NumberLiteral) && max != 0 %}
        {{ max.raise "Non-zero number values have to be specified with a unit, for example: #{max}.px" }}
      {% end %}

      _minmax({{min}}, {{max}})
    end

    def self._minmax(min : CSS::GridFixedBreadth, max : CSS::GridTrackBreadth)
      CSS::GridMinmaxFixedFunctionCall.new(min, max)
    end

    def self._minmax(min : CSS::GridInflexibleBreadth, max : CSS::GridFixedBreadth)
      CSS::GridMinmaxFixedFunctionCall.new(min, max)
    end

    def self._minmax(min : CSS::GridInflexibleBreadth, max : CSS::GridTrackBreadth)
      CSS::GridMinmaxFunctionCall.new(min, max)
    end

    macro repeat(count, *tracks)
      {% if tracks.empty? %}
        {{ raise "repeat requires at least one track value" }}
      {% end %}

      {% for track in tracks %}
        {% if track.is_a?(NumberLiteral) && track != 0 %}
          {{ track.raise "Non-zero number values have to be specified with a unit, for example: #{track}.px" }}
        {% end %}
      {% end %}

      _repeat({{count}}, {{tracks.splat}})
    end

    def self._repeat(count : Int32, *names : CSS::GridLineNames)
      CSS::GridNameRepeatFunctionCall.new(count, *names)
    end

    def self._repeat(count : CSS::Enums::GridAutoRepeat, *names : CSS::GridLineNames)
      CSS::GridNameRepeatFunctionCall.new(count, *names)
    end

    def self._repeat(count : CSS::Enums::GridAutoRepeat, *tracks : CSS::GridRepeatFixedItem)
      CSS::GridAutoRepeatFunctionCall.new(count, *tracks)
    end

    def self._repeat(count : Int32, *tracks : CSS::GridRepeatTrackItem)
      CSS::GridTrackRepeatFunctionCall.new(count, *tracks)
    end

    def self.rgb(r, g, b, *, alpha = nil, from = nil)
      RgbFunctionCall.new(r, g, b, alpha: alpha, from: from)
    end

    alias LinearGradientDirection = CSS::LinearGradientSide | CSS::Angle
    alias LinearGradientStop = Color | CSS::LengthPercentage | Tuple(Color, CSS::LengthPercentage?) | Tuple(Color, CSS::LengthPercentage, CSS::LengthPercentage?)
    alias RadialGradientStop = LinearGradientStop

    def self.linear_gradient(direction : LinearGradientDirection, *stops : LinearGradientStop)
      LinearGradientFunctionCall.new(direction, *stops)
    end

    def self.linear_gradient(*stops : LinearGradientStop)
      LinearGradientFunctionCall.new(*stops)
    end

    # Helper to build an `at` clause for radial gradients.
    # Position helper for radial gradients. Overloads mirror <position> grammar.
    def self.at(position : CSS::Enums::RadialGradientPosition | CSS::LengthPercentage)
      CSS::RadialGradientAt.new(position)
    end

    def self.at(x : CSS::Enums::RadialGradientPosition | CSS::LengthPercentage,
                y : CSS::Enums::RadialGradientPosition | CSS::LengthPercentage)
      CSS::RadialGradientAt.new(x, y)
    end

    # Edge offsets (e.g., left 10% top 20% or top 20% left 10%)
    def self.at(x_keyword : CSS::Enums::RadialGradientPosition, x_offset : CSS::LengthPercentage,
                y_keyword : CSS::Enums::RadialGradientPosition, y_offset : CSS::LengthPercentage)
      CSS::RadialGradientAt.new(x_keyword, x_offset, y_keyword, y_offset)
    end

    # Radial gradients: overloads cover shape/size/position combinations; stops
    # are passed as RadialGradientStop.

    # Stops only
    def self.radial_gradient(*stops : RadialGradientStop)
      RadialGradientFunctionCall.new(*stops)
    end

    # Extent only
    def self.radial_gradient(extent : CSS::Enums::RadialGradientExtent, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({extent}, *stops)
    end

    def self.radial_gradient(extent : CSS::Enums::RadialGradientExtent, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({extent, at}, *stops)
    end

    # Shape only
    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape}, *stops)
    end

    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, at}, *stops)
    end

    # Shape + extent
    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, extent : CSS::Enums::RadialGradientExtent, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, extent}, *stops)
    end

    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, extent : CSS::Enums::RadialGradientExtent, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, extent, at}, *stops)
    end

    # Shape + radius (single)
    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, radius : CSS::LengthPercentage, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, radius}, *stops)
    end

    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, radius : CSS::LengthPercentage, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, radius, at}, *stops)
    end

    # Shape + radius pair
    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, radius_x : CSS::LengthPercentage, radius_y : CSS::LengthPercentage, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, radius_x, radius_y}, *stops)
    end

    def self.radial_gradient(shape : CSS::Enums::RadialGradientShape, radius_x : CSS::LengthPercentage, radius_y : CSS::LengthPercentage, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({shape, radius_x, radius_y, at}, *stops)
    end

    # Radius only (uses default shape)
    def self.radial_gradient(radius : CSS::LengthPercentage, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({radius}, *stops)
    end

    def self.radial_gradient(radius : CSS::LengthPercentage, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({radius, at}, *stops)
    end

    # Radius pair only
    def self.radial_gradient(radius_x : CSS::LengthPercentage, radius_y : CSS::LengthPercentage, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({radius_x, radius_y}, *stops)
    end

    def self.radial_gradient(radius_x : CSS::LengthPercentage, radius_y : CSS::LengthPercentage, at : CSS::RadialGradientAt, *stops : RadialGradientStop)
      RadialGradientFunctionCall.new({radius_x, radius_y, at}, *stops)
    end

    def self.url(value)
      UrlFunctionCall.new(value)
    end

    macro transform(*values)
      {% if values.empty? %}
        {{ raise "transform requires at least one value" }}
      {% end %}

      _transform(
        {% for value, i in values %}
          CSS::TransformFunctions.dispatch({{value}}){% if i < values.size - 1 %}, {% end %}
        {% end %}
      )
    end

    def self._transform(*values : TransformValue)
      property("transform", values.map(&.to_css_value).join(" "))
    end

    macro font_face(klass_name, *, name, &blk)
      class {{klass_name}} < CSS::FontFace
        def self.font_name
          {{name.id.stringify}}
        end

        def self.to_s(io : IO)
          {% if blk.body.is_a?(Expressions) %}
            {% for exp in blk.body.expressions %}
              io << {{exp}}
              io << "\n"
            {% end %}
          {% else %}
            io << {{blk.body}}
          {% end %}
        end
      end

      embed({{klass_name}})
    end

    macro media(queries, &blk)
      class MediaStyle{{@caller.first.line_number}} < CSS::MediaStylesheet
        def self.media_queries
          CSS::MediaQueryEvaluator.evaluate do
            {{queries}}
          end
        end

        {{blk.body}}
      end

      embed MediaStyle{{@caller.first.line_number}}
    end

    macro embed(klass_name)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        {{klass_name}}.to_s(io)
      end
    end
  end
end

require "./css/media_stylesheet"
