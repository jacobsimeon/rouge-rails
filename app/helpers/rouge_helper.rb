module RougeHelper
  def code_sample(name, language)
    render(partial: name, locals: { language: language })
  end
end
