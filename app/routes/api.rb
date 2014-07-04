class WebmentionApp < Sinatra::Base
  before '/api/*' do
    content_type :json
  end

  get '/api/webmentions' do
    if params[:target]
      webmentions = Webmention.where(target: URI.unescape(params[:target]))
    else
      webmentions = Webmention.all
    end

    erb webmentions.to_json, layout: false
  end

  get '/api/webmentions/:id' do
    webmention = Webmention.where(id: params[:id])

    erb webmention.to_json, layout: false
  end
end