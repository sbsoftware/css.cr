module CSS
  alias GridLineNameValue = String | Symbol

  # A `span` grid line. Components are emitted in the canonical integer-then-name form.
  struct GridSpan
    getter count : Int32?
    getter name : String?

    def initialize(@count = nil, name : GridLineNameValue? = nil)
      raise ArgumentError.new("grid span requires a positive count") if @count.try(&.<= 0)
      raise ArgumentError.new("grid span requires a count or name") unless @count || name
      @name = name.try(&.to_s)
    end

    def to_css_value
      String.build do |io|
        io << "span"
        io << " " << count if count
        io << " " << name if name
      end
    end
  end

  alias GridLine = Int32 | Symbol | GridSpan | CSS::Enums::Auto | CSS::Enums::Global

  struct GridAutoFlowShorthand
    getter dense : Bool

    def initialize(@dense = false)
    end

    def to_css_value
      dense ? "auto-flow dense" : "auto-flow"
    end
  end

  # A typed track list used to disambiguate grid shorthand axes.
  struct GridTrackList
    getter value : String

    def initialize(*values : GridTrackListValue)
      raise ArgumentError.new("grid track list requires at least one value") if values.empty?
      @value = values.map(&.to_css_value).join(" ")
    end

    def initialize(value : CSS::Enums::None | CSS::Enums::Masonry | CSS::Enums::Global)
      @value = value.to_css_value
    end

    def initialize(value : CSS::Enums::Subgrid, *names : GridLineNameListItem)
      @value = String.build do |io|
        io << value.to_css_value
        io << " " << names.map(&.to_css_value).join(" ") unless names.empty?
      end
    end

    def to_css_value
      value
    end
  end

  # `<track-size>+`, used by implicit grid tracks and the grid shorthand.
  struct GridAutoTrackList
    getter tracks : Array(GridTrackSize)

    def initialize(*tracks : GridTrackSize)
      raise ArgumentError.new("grid auto track list requires at least one track size") if tracks.empty?
      @tracks = tracks.map(&.as(GridTrackSize)).to_a
    end

    def to_css_value
      tracks.map(&.to_css_value).join(" ")
    end
  end

  # One quoted row in a grid area template, optionally paired with its row size.
  struct GridTemplateAreaRow
    getter areas : String
    getter size : GridTrackSize?
    getter before : GridLineNames?
    getter after : GridLineNames?

    def initialize(@areas, @size = nil, @before = nil, @after = nil)
    end

    def to_css_value
      String.build do |io|
        io << before.not_nil!.to_css_value << " " if before
        io << areas.dump
        io << " " << size.not_nil!.to_css_value if size
        io << " " << after.not_nil!.to_css_value if after
      end
    end
  end
end
