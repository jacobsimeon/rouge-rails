require "spec_helper"

describe Rouge::Rails do
  it "has a version number" do
    expect(Rouge::Rails::VERSION).not_to be nil
  end

  it "registers the rouge template handler" do
    initializer = Rouge::Rails::Railtie.initializers.find { |i|
      i.name == "rouge.rails.register_template_handler"
    }

    initializer.run

    handler = ActionView::Template.handler_for_extension(:rouge)
    expect(handler).to eq(Rouge::Rails::TemplateHandler)
  end

  it "defines a rails engine so that assets are in asset path" do
    expect(Rouge::Rails::Engine.superclass).to be(::Rails::Engine)
  end
end
