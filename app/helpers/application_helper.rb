module ApplicationHelper
  class SyntaxHighlight < Redcarpet::Render::HTML
    def block_code(code, language)
      language = language || :html
      CodeRay.scan(code, language).div(line_numbers: :table)
    rescue
      CodeRay.scan(code, :html).div(line_numbers: :table)
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

  def view_tags(tags=[])
    result = ''
    tags.each do |v|
      bt = content_tag :button, v, {class: "btn btn-success btn-xs"}
      result += content_tag :span, bt
    end
    result.html_safe
  end
end
