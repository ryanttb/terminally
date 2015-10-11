json.array!(@pages) do |page|
  json.extract! page, :id, :url, :cache_text, :cache_image
  json.url page_url(page, format: :json)
end
