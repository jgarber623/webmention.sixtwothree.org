class WebmentionApp < Sinatra::Base
  namespace '/webmentions' do
    get '' do
      @webmentions = Webmention.all.order(created_at: :desc)

      erb :'webmentions/index'
    end

    get '/:id' do
      if @webmention = Webmention.find(params[:id])
        @page_title = @webmention.created_at.to_s(:iso8601)

        erb :'webmentions/show'
      else
        404
      end
    end
  end
end