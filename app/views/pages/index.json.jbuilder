json.array!(@pages) do |page|
  json.extract! page, :id, :title, :body, :tag, :user_name
  json.url page_url(page, format: :json)
end
