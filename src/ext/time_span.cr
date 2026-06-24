struct Time::Span
  def to_css_value
    if total_seconds == total_seconds.to_i64
      "#{total_seconds.to_i64}s"
    elsif total_milliseconds == total_milliseconds.to_i64
      "#{total_milliseconds.to_i64}ms"
    else
      "#{total_seconds}s"
    end
  end
end
