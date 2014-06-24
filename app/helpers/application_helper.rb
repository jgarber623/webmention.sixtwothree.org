def base_url
  @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
end

def link_to(body, url, html_options = {})
  attributes = ''
  html_options.each {|key, value| attributes << key.to_s << '="' << value << '"'}

  "<a href=\"#{url}\" #{attributes}>#{body}</a>"
end

def webmention_url(id)
  "#{base_url}/webmentions/#{id}"
end