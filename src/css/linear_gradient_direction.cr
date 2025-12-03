module CSS
  # Enumerates allowed keyword directions for linear-gradient().
  # Names include the leading `to_` so callers can pass symbols like :to_top_left.
  enum LinearGradientSide
    ToTop
    ToBottom
    ToLeft
    ToRight
    ToTopLeft
    ToTopRight
    ToBottomLeft
    ToBottomRight

    def to_css_value
      String.build do |str|
        str << "to "
        case self
        when .to_top?          then str << "top"
        when .to_bottom?       then str << "bottom"
        when .to_left?         then str << "left"
        when .to_right?        then str << "right"
        when .to_top_left?     then str << "top left"
        when .to_top_right?    then str << "top right"
        when .to_bottom_left?  then str << "bottom left"
        when .to_bottom_right? then str << "bottom right"
        end
      end
    end
  end
end
