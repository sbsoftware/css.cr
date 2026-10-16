require "./spec_helper"

class WritingModeStyle < CSS::Stylesheet
  rule div do
    writing_mode :horizontal_tb
    writing_mode :vertical_rl
    writing_mode :vertical_lr
    writing_mode :sideways_rl
    writing_mode :sideways_lr
  end
end

describe "WritingModeStyle.to_s" do
  it "serializes typed writing-mode values" do
    WritingModeStyle.to_s.should eq(<<-CSS)
    div {
      writing-mode: horizontal-tb;
      writing-mode: vertical-rl;
      writing-mode: vertical-lr;
      writing-mode: sideways-rl;
      writing-mode: sideways-lr;
    }
    CSS
  end
end
