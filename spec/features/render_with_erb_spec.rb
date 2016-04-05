require "feature_helper"

feature "rendering a rouge template from within a rails app" do
  it "can handle files without ERB" do
    visit home_path
    expect(page).to have_css(".highlight code span.s2", text: "basic template")
  end

  it "can handle files with erb" do
    visit home_path
    expect(page).to have_css(".highlight code span.s2", text: "hello world")
  end
end
