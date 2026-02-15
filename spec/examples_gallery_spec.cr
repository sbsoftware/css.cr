require "./spec_helper"

describe "examples gallery" do
  it "contains at least five standalone examples" do
    example_files = Dir.glob("examples/*.md")
      .reject { |path| File.basename(path) == "README.md" }

    example_files.size.should be >= 5
  end

  it "includes Crystal DSL and rendered CSS in each example file" do
    example_files = Dir.glob("examples/*.md")
      .reject { |path| File.basename(path) == "README.md" }
      .sort

    example_files.each do |path|
      content = File.read(path)
      content.should contain("## Crystal DSL")
      content.should contain("## Rendered CSS")

      # Keep examples copy/paste-ready by requiring fenced Crystal and CSS snippets.
      content.should match(/```crystal\s+.+?\s+```/m)
      content.should match(/```css\s+.+?\s+```/m)
    end
  end
end
