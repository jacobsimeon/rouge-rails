module Rouge::Rails
  class TemplateHandler
    def self.call(template, source=nil)
      new(template, source).call
    end

    attr_accessor :template, :source

    def initialize(template, source=nil)
      @template = template
      @source = source
    end

    def call
      %{
        lexer = #{lexer}
        formatter = Rouge::Formatters::HTML.new(css_class: "#{colorscheme}")
        formatter.format(lexer.lex(#{erb_source})).html_safe
      }
    end

    def lexer
      if template.locals.include?("language")
        "Rouge::Lexer.find(language) || #{default_lexer}"
      else
        default_lexer
      end
    end

    def colorscheme
      if template.locals.include?("colorscheme")
        "highlight \#{colorscheme}"
      else
        "highlight #{Rouge::Rails.configuration.default_colorscheme}"
      end
    end

    # Starting with Rails 6, the ActionView template handler for ERB now takes 2 arguments,
    # instead of just 1. This is how we can make it work for both Rails < 6 and Rails >= 6.
    def call_erb_handler(template, source=nil)
      # Rails >= 6
      erb_handler.call(template, source)
    rescue ArgumentError
      # Rails < 6
      erb_handler.call(template)
    end

    def erb_source
      "begin; #{call_erb_handler(template, source)} end"
    end

    def default_lexer
      "Rouge::Lexers::PlainText"
    end

    def self.erb_handler
      @erb_handler ||= ActionView::Template.handler_for_extension(:erb)
    end

    def erb_handler
      self.class.erb_handler
    end

  end
end
