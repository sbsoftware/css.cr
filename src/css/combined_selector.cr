require "./selector"

module CSS
  class CombinedSelector < Selector
    getter first : Selector
    getter second : Selector

    def initialize(@first, @second); end

    def to_s(io : IO)
      selectors = [first, second].reduce([] of Selector) do |acc, selector|
        acc + flatten_selectors(selector)
      end

      ordered = selectors.map_with_index do |selector, index|
        {selector: selector, group: selector_group(selector), index: index}
      end
      ordered.sort_by! { |entry| {entry[:group], entry[:index]} }

      ordered.each do |entry|
        io << entry[:selector]
      end
    end

    private def flatten_selectors(selector : Selector) : Array(Selector)
      case selector
      when CSS::CombinedSelector
        [selector.first, selector.second].reduce([] of Selector) do |acc, item|
          acc + flatten_selectors(item)
        end
      else
        [selector]
      end
    end

    private def selector_group(selector : Selector) : Int32
      case selector
      when CSS::AttrSelector
        2
      when CSS::AnySelector
        0
      when CSS::StringSelector
        string_group(selector.string)
      when CSS::PseudoclassSelector
        tag_like?(selector.element_selector) ? 0 : 1
      else
        1
      end
    end

    private def string_group(value : String) : Int32
      return 2 if value.starts_with?("[")
      string_tag_like?(value) ? 0 : 1
    end

    private def tag_like?(selector : Selector) : Bool
      case selector
      when CSS::AnySelector
        true
      when CSS::StringSelector
        string_tag_like?(selector.string)
      when CSS::CombinedSelector
        tag_like?(selector.first) || tag_like?(selector.second)
      else
        false
      end
    end

    private def string_tag_like?(value : String) : Bool
      return false if value.empty?

      first = value[0]
      first.ascii_letter? || first == '*'
    end
  end
end
