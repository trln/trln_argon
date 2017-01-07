# TRLN Argon Rails Engine
The TRLN Argon Rails Engine provides additional templates, styles, search builder behaviors, catalog controller overrides, and other features to bootstrap a Blacklight catalog for the TRLN shared catalog index.

## Usage

Default configurations can be changed in: `your_app/config/trln_argon_config.yml`

Sass variables and other styles may be overridden in: `your_app/assets/stylesheets/trln_argon.scss`

## Installation

Create a new Rails application:

```bash
$ rails new my_terrific_catalog
```

Install Solr and Blacklight, run the Blacklight generator, start Solr, and index some data. For now, let's assume we're using the out of the box Blacklight schema with the demo data. Detailed instructions on the [Blacklight Quickstart Guide](https://github.com/projectblacklight/blacklight/wiki/Quickstart), but generally:

```bash
$ gem install solr_wrapper
```

Add this line to your Gemfile:
```
gem 'blacklight', "~> 6.7"
```

Run the following:

```bash
$ bundle install
$ rails generate blacklight:install --devise --marc --solr_version=latest
$ rake db:migrate
$ bundle exec solr_wrapper
$ rake solr:marc:index_test_data
```

Add this line to your application's Gemfile:

```ruby
gem 'trln_argon', git: 'https://github.com/trln/trln_argon.git'
```

And then execute:
```bash
$ bundle install
```

Run the TRLN Argon generator
```bash
$ rails generate trln_argon:install
```

You can see what the generator does in this file: [install_generator.rb](https://github.com/trln/trln_argon/blob/master/lib/generators/trln_argon/install_generator.rb)

Start the Rails server:
```bash
$ rails server
```

The TRLN Argon Blacklight catalog should now be available at [http://localhost:3000](http://localhost:3000).

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
