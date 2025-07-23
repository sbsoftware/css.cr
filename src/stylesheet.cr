require "./css/any_selector"
require "./css/string_selector"
require "./css/descendant_selector"
require "./css/child_selector"
require "./css/combined_selector"
require "./css/attr_selector"
require "./css/pseudoclass_selector"
require "./css/named_color"
require "./css/enums/**"

module CSS
  class Stylesheet
    macro rule(selector_expression, &blk)
      def self.to_s(io : IO)
        {% if @type.class.methods.map(&.name.stringify).includes?("to_s") %}
          previous_def
          io << "\n\n"
        {% end %}

        make_rule(io, make_selector({{selector_expression}})) {{blk}}
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

    macro make_rule(io, selector, &blk)
      %child_rules = String.build do |%child_rule_io|
        {{io}} << {{selector}}
        {{io}} << " {\n"
        {% if blk.body.is_a?(Expressions) %}
          {% prop_exprs = blk.body.expressions.reject { |exp| exp.is_a?(Call) && exp.name.stringify == "rule" && exp.args.size == 1 && exp.block } %}
          {% for exp, i in blk.body.expressions %}
            {% if exp.is_a?(Call) && exp.name.stringify == "rule" && exp.args.size == 1 && exp.block %}
              make_rule(%child_rule_io, CSS::DescendantSelector.new({{selector}}, make_selector({{exp.args.first}}))) {{exp.block}}
            {% else %}
              {{io}} << "  "
              {{io}} << {{exp}}
              {% if prop_exprs.size > 1 && i < prop_exprs.size - 1 %}
                {{io}} << "\n"
              {% end %}
            {% end %}
          {% end %}
        {% else %}
          {% if blk.body.is_a?(Call) && blk.body.name.stringify == "rule" && blk.body.args.size == 1 && blk.body.block %}
            make_rule(%child_rule_io, CSS::DescendantSelector.new({{selector}}, make_selector({{blk.body.args.first}}))) {{blk.body.block}}
          {% else %}
            {{io}} << "  "
            {{io}} << {{blk.body}}
          {% end %}
        {% end %}
        {{io}} << "\n}"
      end

      if %child_rules.size.positive?
        {{io}} << "\n\n"
        {{io}} << %child_rules
      end
    end

    macro prop(name, type)
      def self.{{name.id}}(value : {{type}} | CSS::Enums::Global)
        property({{name.stringify.gsub(/_/, "-")}}, value)
      end
    end

    macro prop2(name, type1, type2)
      def self.{{name.id}}(value1 : {{type1}}, value2 : {{type2}})
        property({{name.stringify.gsub(/_/, "-")}}, "#{value1} #{value2}")
      end
    end

    def self.property(name, value)
      "#{name}: #{value.to_s.underscore.gsub(/_/, "-")};"
    end

    prop accent_color, String
    prop align_content, CSS::Enums::AlignContent | CSS::Enums::AlignContentPositional | CSS::Enums::AlignmentBaseline
    prop2 align_content, CSS::Enums::Safety, CSS::Enums::AlignContentPositional
    prop2 align_content, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline
    prop align_items, CSS::Enums::AlignItems | CSS::Enums::AlignItemsPositional | CSS::Enums::AlignmentBaseline
    prop2 align_items, CSS::Enums::Safety, CSS::Enums::AlignItemsPositional
    prop2 align_items, CSS::Enums::FirstLast, CSS::Enums::AlignmentBaseline
    prop align_self, String
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
    prop aspect_ratio, String
    prop backdrop_filter, String
    prop backface_visibility, String
    prop background, String
    prop background_attachment, String
    prop background_blend_mode, String
    prop background_clip, String
    prop background_color, CSS::NamedColor | String
    prop background_image, String
    prop background_origin, String
    prop background_position, String
    prop background_position_x, String
    prop background_position_y, String
    prop background_repeat, String
    prop background_size, String
    prop baseline_shift, String
    prop block_size, String
    prop border, String
    prop border_block, String
    prop border_block_color, String
    prop border_block_end, String
    prop border_block_end_color, String
    prop border_block_end_style, String
    prop border_block_end_width, String
    prop border_block_start, String
    prop border_block_start_color, String
    prop border_block_start_style, String
    prop border_block_start_width, String
    prop border_block_style, String
    prop border_block_width, String
    prop border_bottom, String
    prop border_bottom_color, String
    prop border_bottom_left_radius, String
    prop border_bottom_right_radius, String
    prop border_bottom_style, String
    prop border_bottom_width, String
    prop border_collapse, String
    prop border_color, CSS::NamedColor | String
    prop border_end_end_radius, String
    prop border_end_start_radius, String
    prop border_image, String
    prop border_image_outset, String
    prop border_image_repeat, String
    prop border_image_slice, String
    prop border_image_source, String
    prop border_image_width, String
    prop border_inline, String
    prop border_inline_color, String
    prop border_inline_end, String
    prop border_inline_end_color, String
    prop border_inline_end_style, String
    prop border_inline_end_width, String
    prop border_inline_start, String
    prop border_inline_start_color, String
    prop border_inline_start_style, String
    prop border_inline_start_width, String
    prop border_inline_style, String
    prop border_inline_width, String
    prop border_left, String
    prop border_left_color, String
    prop border_left_style, String
    prop border_left_width, String
    prop border_radius, String
    prop border_right, String
    prop border_right_color, String
    prop border_right_style, String
    prop border_right_width, String
    prop border_spacing, String
    prop border_start_end_radius, String
    prop border_start_start_radius, String
    prop border_style, String
    prop border_top, String
    prop border_top_color, String
    prop border_top_left_radius, String
    prop border_top_right_radius, String
    prop border_top_style, String
    prop border_top_width, String
    prop border_width, String
    prop bottom, String
    prop box_decoration_break, String
    prop box_shadow, String
    prop box_sizing, String
    prop break_after, String
    prop break_before, String
    prop break_inside, String
    prop caption_side, String
    prop caret, String
    prop caret_color, String
    prop caret_shape, String
    prop clear, String
    prop clip_path, String
    prop clip_rule, String
    prop color, String
    prop color_interpolation_filters, String
    prop color_scheme, String
    prop column_count, Int
    prop column_fill, String
    prop column_gap, String
    prop column_rule, String
    prop column_rule_color, String
    prop column_rule_style, String
    prop column_rule_width, String
    prop column_span, String
    prop column_width, String
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
    prop cursor, String
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
    prop flex, String
    prop flex_basis, String
    prop flex_direction, CSS::Enums::FlexDirection
    prop flex_flow, CSS::Enums::FlexDirection | CSS::Enums::FlexWrap
    prop2 flex_flow, CSS::Enums::FlexDirection, CSS::Enums::FlexWrap
    prop flex_grow, Number
    prop flex_shrink, Int
    prop flex_wrap, CSS::Enums::FlexWrap
    prop float, String
    prop flood_color, String
    prop flood_opacity, String
    prop font, String
    prop font_family, String
    prop font_feature_settings, String
    prop font_kerning, String
    prop font_language_override, String
    prop font_optical_sizing, String
    prop font_palette, String
    prop font_size, String
    prop font_size_adjust, String
    prop font_style, String
    prop font_synthesis, String
    prop font_synthesis_small_caps, String
    prop font_synthesis_style, String
    prop font_synthesis_weight, String
    prop font_variant, String
    prop font_variant_alternates, String
    prop font_variant_caps, String
    prop font_variant_east_asian, String
    prop font_variant_emoji, String
    prop font_variant_ligatures, String
    prop font_variant_numeric, String
    prop font_variant_position, String
    prop font_variation_settings, String
    prop font_weight, Int | String
    prop forced_color_adjust, String
    prop gap, String
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
    prop grid_template_columns, String
    prop grid_template_rows, String
    prop hanging_punctuation, String
    prop height, CSS::LengthValue
    prop hyphenate_character, String
    prop hyphenate_limit_chars, String
    prop hyphens, String
    prop image_orientation, String
    prop image_rendering, String
    prop initial_letter, String
    prop inline_size, String
    prop inset, String
    prop inset_block, String
    prop inset_block_end, String
    prop inset_block_start, String
    prop inset_inline, String
    prop inset_inline_end, String
    prop inset_inline_start, String
    prop isolation, String
    prop justify_content, CSS::Enums::JustifyContent | CSS::Enums::JustifyContentPositional
    prop2 justify_content, CSS::Enums::Safety, CSS::Enums::JustifyContentPositional
    prop justify_items, String
    prop justify_self, String
    prop left, String
    prop letter_spacing, String
    prop lighting_color, String
    prop line_break, String
    prop line_clamp, Int | String
    prop line_height, String
    prop list_style, String
    prop list_style_image, String
    prop list_style_position, String
    prop list_style_type, String
    prop margin, String
    prop margin_block, String
    prop margin_block_end, String
    prop margin_block_start, String
    prop margin_bottom, String
    prop margin_inline, String
    prop margin_inline_end, String
    prop margin_inline_start, String
    prop margin_left, String
    prop margin_right, String
    prop margin_top, String
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
    prop max_block_size, String
    prop max_height, CSS::LengthValue
    prop max_inline_size, String
    prop max_width, CSS::LengthValue
    prop min_block_size, String
    prop min_height, CSS::LengthValue
    prop min_inline_size, String
    prop min_width, CSS::LengthValue
    prop mix_blend_mode, String
    prop object_fit, String
    prop object_position, String
    prop offset, String
    prop offset_anchor, String
    prop offset_distance, String
    prop offset_path, String
    prop offset_position, String
    prop offset_rotate, String
    prop opacity, Int | Float
    prop order, Int
    prop orphans, Int
    prop outline, String
    prop outline_color, String
    prop outline_offset, String
    prop outline_style, String
    prop outline_width, String
    prop overflow, String
    prop overflow_anchor, String
    prop overflow_block, String
    prop overflow_clip_margin, String
    prop overflow_inline, String
    prop overflow_wrap, String
    prop overflow_x, String
    prop overflow_y, String
    prop overscroll_behavior, String
    prop overscroll_behavior_block, String
    prop overscroll_behavior_inline, String
    prop overscroll_behavior_x, String
    prop overscroll_behavior_y, String
    prop padding, String
    prop padding_block, String
    prop padding_block_end, String
    prop padding_block_start, String
    prop padding_bottom, String
    prop padding_inline, String
    prop padding_inline_end, String
    prop padding_inline_start, String
    prop padding_left, String
    prop padding_right, String
    prop padding_top, String
    prop page, String
    prop paint_order, String
    prop perspective, String
    prop perspective_origin, String
    prop place_content, String
    prop place_items, String
    prop place_self, String
    prop pointer_events, String
    prop position, String
    prop print_color_adjust, String
    prop quotes, String
    prop r, String
    prop resize, String
    prop right, String
    prop rotate, String
    prop row_gap, String
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
    prop text_align, String
    prop text_align_last, String
    prop text_anchor, String
    prop text_box, String
    prop text_box_edge, String
    prop text_box_trim, String
    prop text_combine_upright, String
    prop text_decoration, String
    prop text_decoration_color, String
    prop text_decoration_line, String
    prop text_decoration_skip_ink, String
    prop text_decoration_style, String
    prop text_decoration_thickness, String
    prop text_emphasis, String
    prop text_emphasis_color, String
    prop text_emphasis_position, String
    prop text_emphasis_style, String
    prop text_indent, String
    prop text_justify, String
    prop text_orientation, String
    prop text_overflow, String
    prop text_rendering, String
    prop text_shadow, String
    prop text_transform, String
    prop text_underline_offset, String
    prop text_underline_position, String
    prop text_wrap, String
    prop text_wrap_mode, String
    prop text_wrap_style, String
    prop top, String
    prop touch_action, String
    prop transform, String
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
    prop user_select, String
    prop vector_effect, String
    prop vertical_align, String
    prop view_transition_class, String
    prop view_transition_name, String
    prop visibility, String
    prop white_space, String
    prop white_space_collapse, String
    prop widows, Int
    prop width, CSS::LengthValue
    prop will_change, String
    prop word_break, String
    prop word_spacing, String
    prop word_wrap, String
    prop writing_mode, String
    prop x, String
    prop y, String
    prop z_index, Int
    prop zoom, String
  end
end
