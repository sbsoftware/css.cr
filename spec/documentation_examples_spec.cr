require "./spec_helper"

module CSS::DocumentationExamplesSpec
  css_class Card
  css_class Button
  css_id HeroBanner

  class Style < CSS::Stylesheet
    font_face UiSans, name: "UiSans" do
      src local("UiSans"), url("/fonts/ui-sans.woff2")
    end

    rule body do
      margin 0
      font_family UiSans, :sans_serif
      background linear_gradient(:to_right, {"#f8fafc", 0.percent}, {"#e2e8f0", 100.percent})
    end

    rule Card do
      padding 16.px
      border_radius 12.px
      box_shadow 0.px, 4.px, 20.px, rgb(15, 23, 42, alpha: 20.percent)
    end

    rule Card > Button do
      font_weight :bold
    end

    rule Button && "[aria-pressed='true']" do
      color :white, important: true
      background_color "#2563eb", important: true
    end

    rule HeroBanner <= :before do
      content "Beta"
      margin_right 8.px
    end

    media(max_width 640.px) do
      rule Card do
        padding 12.px
        width calc(100.percent - 24.px)
      end
    end
  end

  describe "Style.to_s" do
    it "renders the documented guide patterns" do
      expected = <<-CSS
      @font-face {
        font-family: "UiSans";
        src: local("UiSans"), url("/fonts/ui-sans.woff2");
      }

      body {
        margin: 0;
        font-family: "UiSans", sans-serif;
        background: linear-gradient(to right, #f8fafc 0%, #e2e8f0 100%);
      }

      .css--documentation-examples-spec--card {
        padding: 16px;
        border-radius: 12px;
        box-shadow: 0px 4px 20px rgb(15, 23, 42, 20%);
      }

      .css--documentation-examples-spec--card > .css--documentation-examples-spec--button {
        font-weight: bold;
      }

      .css--documentation-examples-spec--button[aria-pressed='true'] {
        color: white !important;
        background-color: #2563eb !important;
      }

      #css--documentation-examples-spec--hero-banner:before {
        content: "Beta";
        margin-right: 8px;
      }

      @media (max-width: 640px) {
        .css--documentation-examples-spec--card {
          padding: 12px;
          width: calc(100% - 24px);
        }
      }
      CSS

      Style.to_s.should eq(expected)
    end
  end
end
