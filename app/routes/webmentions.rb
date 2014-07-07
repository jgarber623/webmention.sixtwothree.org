class WebmentionApp < Sinatra::Base
  get '/webmentions' do
    @webmentions = Webmention.all.order(created_at: :desc)

    erb :'webmentions/index'
  end

  get '/webmentions/:id' do
    if @webmention = Webmention.find(params[:id])
      @page_title = @webmention.created_at.strftime('%FT%T%:z')

      erb :'webmentions/show'
    else
      404
    end
  end
end