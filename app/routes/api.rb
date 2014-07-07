class WebmentionApp < Sinatra::Base
  namespace '/api' do
    before { content_type :json }

    get '/webmentions' do
      if params[:target]
        webmentions = Webmention.where(target: params[:target])
      else
        webmentions = Webmention.all
      end

      erb webmentions.to_json, layout: false
    end

    get '/webmentions/:id' do
      webmention = Webmention.where(id: params[:id])

      erb webmention.to_json, layout: false
    end
  end
end