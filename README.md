# webmention.sixtwothree.org

The (current) webmention endpoint for sixtwothree.org, written in [Ruby](https://www.ruby-lang.org/) and [Sinatra](http://www.sinatrarb.com).

This was my first real attempt at building a Sinatra application. I'm fairly certain the code could be improved. In hindsight, it would've made more sense for this to be a small Rails application, but I enjoyed building it nonetheless and it works well enough.

I'll soon be migrating my personal site to [FrancisCMS](https://github.com/jgarber623/FrancisCMS) which means this project will be deprecated. It's unlikely the code will see any further development, but I want to make it available here for posterity's sake.

## Installation

1. Install Ruby 2.1.1 using your version manager of choice (e.g. [rbenv](https://github.com/sstephenson/rbenv), [RVM](https://rvm.io), [chruby](https://github.com/postmodern/chruby), etc.).
1. Install [Bundler](http://bundler.io): `gem install bundler`.
1. Install gems: `bundle install`
1. Create and migrate the database: `rake db:create db:migrate`.

## Developing

To start the application in development mode, run `bundle exec shotgun` from the root of the project and point your favorite web browser to [http://localhost:9393/](http://localhost:9393/).

### Configuring the application

There are a number of places where `sixtwothree.org`-related strings are hard-coded in the application. You'll want to find those places and change them to match your domain.

### Receiving webmentions

For development purposes, it's easiest to send webmentions to the application from the command line:

	curl -i -d 'source=http://example.com/foo/bar&target=http://sixtwothree.org/biz/baz' http://localhost:9393

If the incoming webmention is valid, you should be given a URL (e.g. `http://localhost:9393/webmentions/1`) where you can view information about the webmention.

### Verifying webmentions

Verifying webmentions is done on the command line by running the following commands:

	bundle exec tux
	Webmention.verify_all

The `verify_all` method will attempt to verify all webmentions with a null `verified_at`. You may also verify indiviual webmentions using `Webmention.find(1).verify`, replacing `1` with the ID of the webmention you want to verify.

### Using the API

A lightweight JSON API is also available. The following endpoints can be used to return webmentions for consumption in third-party applications:

<table>
	<tr>
		<th>/api/webmentions</th>
		<td>Returns all webmentions</td>
	</tr>
	<tr>
		<th>/api/webmentions?target=:url</th>
		<td>Returns all webmentions where target equals :target</td>
	</tr>
	<tr>
		<th>/api/webmentions/:id</th>
		<td>Returns a webmention with an ID equal to :id</td>
	</tr>
</table>

## Deploying

The application is deployed using [Capistrano](https://github.com/capistrano/capistrano/wiki) by running the command `cap environment deploy` where `environment` matches configuration files in `config/deploy` (e.g. `config/deploy/production.rb`). Deployment largely depends on your host environment, so you'll likely need to make significant changes to the Capistrano set up (or replace it entirely).

## Acknowledgements

Special thanks to [@tpitale](https://github.com/tpitale) for his help and mentorship. I couldn't have launched this thing without him!

## License

Per [CC0](http://creativecommons.org/publicdomain/zero/1.0/), to the extent possible under law, I have waived all copyright and related or neighboring rights to this work. Go forth and make things.