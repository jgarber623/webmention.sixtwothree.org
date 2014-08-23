class WebmentionApp < Sinatra::Base
  namespace '/api' do
    before { content_type :json }

    get '/webmentions' do
      if params[:target]
        webmentions = Webmention.where(target: params[:target])
      else
        webmentions = Webmention.all
      end

      json webmentions
    end

    get '/webmentions/:id' do
      webmention = Webmention.where(id: params[:id]).first

      json webmention
    end
  end
end