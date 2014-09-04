module ApplicationHelper
  class SyntaxHighlight < Redcarpet::Render::HTML
    attr_accessor :header_list, :header_count

    def initialize
      self.header_list  = []
      self.header_count = 0
      super
    end

    def block_code(code, language)
      language = language || :html
      CodeRay.scan(code, language).div
    rescue
      CodeRay.scan(code, :html).div
    end

    def header(text, header_level)
      self.header_list << {text: text, level: header_level}
      self.header_count += 1
      %[<h#{header_level} id="header_no_#{self.header_count}"><a href="#header_no_#{self.header_count}">#{text}</a></h#{header_level}>]
    end

    def get_header_list
      self.header_list
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
    # Redcarpetのtableにclass指定できないので生成されたHTMLで無理やりclass付与
    markdown.render(text).gsub('table', 'table class="table table-hover table-bordered"').html_safe
  end

  def show_markdown(text)
    markdown = Redcarpet::Markdown.new(
      @syntax_high_light=SyntaxHighlight.new,
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      superscript: true

    )
    # Redcarpetのtableにclass指定できないので生成されたHTMLで無理やりclass付与
    result_html = markdown.render(text).gsub('table', 'table class="table table-hover table-bordered"').html_safe
    [result_html, @syntax_high_light.get_header_list]
  end

  def view_tags(tags=[])
    result = ''
    tags.each do |v|
      bt = link_to v, pages_path("page[body]" => v), {class: "btn btn-success btn-xs"}
      result += content_tag :span, bt
    end
    result.html_safe
  end

  # Gravatar (http://gravatar.com/) を表示。
  def gravatar_for(user)
    user = user.presence || User.new(email: 'hoge@example.com', name: 'deleted_user')
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=monsterid"
    image_tag(gravatar_url, alt: user.name, class: "gravatar userIcon")
  end
end
