def base_url
  @base_url ||= request.base_url
end

def link_to(body, url, html_options = {})
  attributes = []

  html_options.each_pair do |key, value|
    attributes << %(#{key}="#{value}")
  end

  "<a href=\"#{url}\" #{attributes.sort * ' '}>#{body}</a>"
end

def webmention_url(id)
  "#{base_url}/webmentions/#{id}"
end