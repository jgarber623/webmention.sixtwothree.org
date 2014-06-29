class WebmentionApp < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    source = params[:source]
    target = params[:target]

    if source.nil? || target.nil?
      status 400
    else
      if webmention = Webmention.where(source: source, target: target).first
        webmention.verified_at = nil
      else
        webmention = Webmention.new({ source: source, target: target })
      end

      if webmention.save
        status 202

        erb "#{base_url}/webmentions/#{webmention.id}", layout: false
      else
        status 400
      end
    end
  end

  not_found do
    erb :'404'
  end
end