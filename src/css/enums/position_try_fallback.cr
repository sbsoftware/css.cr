css_enum PositionTryFallback do
  FlipBlock
  FlipInline
  FlipStart
  FlipBlockFlipInline
  FlipInlineFlipBlock
  FlipStartFlipBlock
  FlipStartFlipInline
end

module CSS::Enums
  enum PositionTryFallback
    def to_css_value
      case self
      when FlipBlockFlipInline
        "flip-block flip-inline"
      when FlipInlineFlipBlock
        "flip-inline flip-block"
      when FlipStartFlipBlock
        "flip-start flip-block"
      when FlipStartFlipInline
        "flip-start flip-inline"
      else
        String.build do |str|
          to_s(str)
        end.underscore.gsub('_', '-')
      end
    end
  end
end
