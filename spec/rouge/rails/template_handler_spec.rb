require "spec_helper"

describe Rouge::Rails::TemplateHandler do
  let(:ruby_source) do
    <<-RUBY
      class MyClass
        def my_method
          puts "hello world"
        end
      end
    RUBY
  end

  context "when no language is specificed" do
    it "Formats a template as plaintext" do
      source = "hello \nworld"
      template = double(:template, source: source, locals: [])
      evalable_ruby = Rouge::Rails::TemplateHandler.call(template)
      formatted_code = Nokogiri::HTML(eval(evalable_ruby))

      pre_tag = formatted_code.css("html body pre")
      expect(pre_tag).to_not be_nil
      expect(pre_tag.text).to eq("hello \nworld")
    end
  end

  context "when a language is specified" do
    it "formats the template in the given langauge" do
      template = double(:template, source: ruby_source, locals: ["language"])
      evalable_ruby = Rouge::Rails::TemplateHandler.call(template)

      language = :ruby
      rendered_template = eval(evalable_ruby)

      formatted_code = Nokogiri::HTML(rendered_template).css(
        "html body pre code"
      )

      highlighted_class_keyword = formatted_code.css("span.k").first
      expect(highlighted_class_keyword).to_not be_nil
      expect(highlighted_class_keyword.text).to eq("class")
    end
  end

  context "when there is no lexer for the specified language" do
    it "defaults to plain text" do
      template = double(:template, source: ruby_source, locals: ["language"])
      evalable_ruby = Rouge::Rails::TemplateHandler.call(template)

      language = :lol_imma_langauge!
      rendered_template = eval(evalable_ruby)

      formatted_code = Nokogiri::HTML(rendered_template).css(
        "html body pre code"
      )

      expect(formatted_code.children.length).to eq(1)
      expect(formatted_code.text).to eq(ruby_source)
    end
  end

  it "uses 'default' as the default colorscheme" do
    source = "hello \nworld"
    template = double(:template, source: source, locals: [])
    evalable_ruby = Rouge::Rails::TemplateHandler.call(template)
    formatted_code = Nokogiri::HTML(eval(evalable_ruby))

    pre_tag = formatted_code.css("html body pre")
    expect(pre_tag.attribute("class").value).to eq("highlight default")
  end

  it "uses the configured colorscheme as the default" do
    old_config = Rouge::Rails.configuration.default_colorscheme
    Rouge::Rails.configure do |config|
      config.default_colorscheme = "solarized-dark"
    end

    source = "hello \nworld"
    template = double(:template, source: source, locals: [])
    evalable_ruby = Rouge::Rails::TemplateHandler.call(template)
    formatted_code = Nokogiri::HTML(eval(evalable_ruby))

    pre_tag = formatted_code.css("html body pre")
    expect(pre_tag.attribute("class").value).to eq("highlight solarized-dark")

    Rouge::Rails.configure do |config|
      config.default_colorscheme = old_config
    end
  end

  it "uses the specified colorscheme when passed as a param" do
    source = "hello \nworld"
    template = double(:template, source: source, locals: ["colorscheme"])

    evalable_ruby = Rouge::Rails::TemplateHandler.call(template)

    colorscheme = "monokai"
    formatted_code = Nokogiri::HTML(eval(evalable_ruby))

    pre_tag = formatted_code.css("html body pre")
    expect(pre_tag.attribute("class").value).to eq("highlight monokai")
  end
end
