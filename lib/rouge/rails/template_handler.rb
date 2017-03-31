module Rouge::Rails
  class TemplateHandler
    def self.call(template)
      new(template).call
    end

    attr_accessor :template

    def initialize(template)
      @template = template
    end

    def call
      %{
        lexer = #{lexer}
        formatter = Rouge::Formatters::HTMLPygments.new(Rouge::Formatters::HTML.new, "#{colorscheme}")
        formatter.format(lexer.lex(#{source})).html_safe
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

    def source
      "begin; #{erb_handler.call(template)} end"
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
