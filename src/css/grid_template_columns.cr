require "./function_call"
require "./min_function_call"

module CSS
  alias GridLineName = String | Symbol

  struct GridLineNames
    getter names : Array(String)

    def initialize(*names : GridLineName)
      @names = names.map(&.to_s).to_a
    end

    def to_s(io : IO)
      io << "["
      io << names.join(" ")
      io << "]"
    end

    def to_css_value
      to_s
    end
  end

  alias GridLengthUnit = CmValue | MmValue | InValue | PxValue | PtValue | PcValue | EmValue | RemValue | ExValue | ChValue | LhValue | RlhValue | VhValue | VwValue | VmaxValue | VminValue | SvwValue | SvhValue | LvwValue | LvhValue | DvwValue | DvhValue
  alias GridLength = GridLengthUnit | Int32 | CalcFunctionCall
  alias GridLengthPercentage = GridLength | PercentValue | CalcFunctionCall | MinFunctionCall

  alias GridTrackBreadth = GridLengthPercentage | CSS::FrValue | CSS::Enums::GridTrackKeyword
  alias GridInflexibleBreadth = GridLengthPercentage | CSS::Enums::GridTrackKeyword
  alias GridFixedBreadth = GridLengthPercentage

  struct GridMinmaxFunctionCall
    include FunctionCall
    getter min : GridInflexibleBreadth
    getter max : GridTrackBreadth

    def initialize(@min : GridInflexibleBreadth, @max : GridTrackBreadth)
    end

    def function_name : String
      "minmax"
    end

    def arguments : String
      "#{min.to_css_value}, #{max.to_css_value}"
    end
  end

  struct GridMinmaxFixedFunctionCall
    include FunctionCall
    getter min : GridFixedBreadth | GridInflexibleBreadth
    getter max : GridTrackBreadth | GridFixedBreadth

    def initialize(@min : GridFixedBreadth, @max : GridTrackBreadth)
    end

    def initialize(@min : GridInflexibleBreadth, @max : GridFixedBreadth)
    end

    def function_name : String
      "minmax"
    end

    def arguments : String
      "#{min.to_css_value}, #{max.to_css_value}"
    end
  end

  struct GridFitContentFunctionCall
    include FunctionCall
    getter size : GridLengthPercentage

    def initialize(@size : GridLengthPercentage)
    end

    def function_name : String
      "fit-content"
    end

    def arguments : String
      size.to_css_value.to_s
    end
  end

  alias GridTrackSize = GridTrackBreadth | GridMinmaxFunctionCall | GridMinmaxFixedFunctionCall | GridFitContentFunctionCall
  alias GridFixedSize = GridFixedBreadth | GridMinmaxFixedFunctionCall

  alias GridRepeatTrackItem = GridLineNames | GridTrackSize
  alias GridRepeatFixedItem = GridLineNames | GridFixedSize

  struct GridTrackRepeatFunctionCall
    include FunctionCall
    getter count : Int32
    getter tracks : Array(GridRepeatTrackItem)

    def initialize(@count : Int32, *tracks : GridRepeatTrackItem)
      @tracks = tracks.map(&.as(GridRepeatTrackItem)).to_a
      validate_tracks
    end

    def function_name : String
      "repeat"
    end

    def arguments : String
      "#{count.to_css_value}, #{format_tracks(tracks)}"
    end

    private def validate_tracks
      has_track_size = tracks.any? { |item| item.is_a?(GridTrackSize) }
      raise ArgumentError.new("repeat() requires at least one track size") unless has_track_size
    end

    private def format_tracks(values)
      values.map(&.to_css_value).join(" ")
    end
  end

  struct GridAutoRepeatFunctionCall
    include FunctionCall
    getter count : CSS::Enums::GridAutoRepeat
    getter tracks : Array(GridRepeatFixedItem)

    def initialize(@count : CSS::Enums::GridAutoRepeat, *tracks : GridRepeatFixedItem)
      @tracks = tracks.map(&.as(GridRepeatFixedItem)).to_a
      validate_tracks
    end

    def function_name : String
      "repeat"
    end

    def arguments : String
      "#{count.to_css_value}, #{format_tracks(tracks)}"
    end

    private def validate_tracks
      has_track_size = tracks.any? { |item| item.is_a?(GridFixedSize) }
      raise ArgumentError.new("repeat(auto-fill/auto-fit, ...) requires at least one fixed track size") unless has_track_size
    end

    private def format_tracks(values)
      values.map(&.to_css_value).join(" ")
    end
  end

  struct GridNameRepeatFunctionCall
    include FunctionCall
    getter count : Int32 | CSS::Enums::GridAutoRepeat
    getter names : Array(GridLineNames)

    def initialize(@count, *names : GridLineNames)
      @names = names.map(&.as(GridLineNames)).to_a
      validate_names
    end

    def function_name : String
      "repeat"
    end

    def arguments : String
      "#{count.to_css_value}, #{format_tracks(names)}"
    end

    private def validate_names
      raise ArgumentError.new("repeat() requires at least one line name group") if names.empty?

      if count.is_a?(CSS::Enums::GridAutoRepeat) && count == CSS::Enums::GridAutoRepeat::AutoFit
        raise ArgumentError.new("repeat(auto-fit, <line-names>+) is not allowed")
      end
    end

    private def format_tracks(values)
      values.map(&.to_css_value).join(" ")
    end
  end

  alias GridTrackListValue = GridLineNames | GridTrackSize | GridTrackRepeatFunctionCall | GridAutoRepeatFunctionCall | GridNameRepeatFunctionCall
  alias GridLineNameListItem = GridLineNames | GridNameRepeatFunctionCall
end
