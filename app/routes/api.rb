class WebmentionApp < Sinatra::Base
  namespace '/api' do
    before { content_type :json }

    get '/webmentions' do
      if params.empty?
        response = Webmention.all
      else
        target = params[:target]

        if target =~ URI::regexp(%w(http https))
          response = Webmention.where('target = ? AND verified_at IS NOT NULL', target)
        else
          status 400

          response = { error: "'#{target}' is not a valid URL." }
        end
      end

      json response
    end

    get '/webmentions/:id' do
      json Webmention.where(id: params[:id])
    end
  end
end