module ApplicationHelper
  class SyntaxHighlight < Redcarpet::Render::HTML
    def block_code(code, language)
      language = language || :html
      CodeRay.scan(code, language).div(line_numbers: :table)
    end
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(
      SyntaxHighlight,
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      superscript: true

    )
    markdown.render(text).html_safe
  end
end
