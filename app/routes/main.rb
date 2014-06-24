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
      status 202

      webmention = Webmention.new({ source: params[:source], target: params[:target] })

      if webmention.save
        erb "#{base_url}/webmentions/#{webmention.id}", layout: false
      end
    end
  end

  not_found do
    erb :'404'
  end
end