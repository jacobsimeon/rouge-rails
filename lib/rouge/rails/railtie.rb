module Rouge::Rails
  class Railtie < ::Rails::Railtie
    initializer "rouge.rails.register_template_handler" do
      ActionView::Template.register_template_handler(
        :rouge,
        Rouge::Rails::TemplateHandler
      )
    end
  end
end
