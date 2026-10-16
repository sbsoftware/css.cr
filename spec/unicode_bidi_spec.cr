require "./spec_helper"

class UnicodeBidiStyle < CSS::Stylesheet
  rule div do
    unicode_bidi :normal
    unicode_bidi :embed
    unicode_bidi :isolate
    unicode_bidi :bidi_override
    unicode_bidi :isolate_override
    unicode_bidi :plaintext
  end
end

describe "UnicodeBidiStyle.to_s" do
  it "serializes typed unicode-bidi values" do
    UnicodeBidiStyle.to_s.should eq(<<-CSS)
    div {
      unicode-bidi: normal;
      unicode-bidi: embed;
      unicode-bidi: isolate;
      unicode-bidi: bidi-override;
      unicode-bidi: isolate-override;
      unicode-bidi: plaintext;
    }
    CSS
  end
end
