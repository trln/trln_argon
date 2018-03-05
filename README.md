# TRLN Argon Rails Engine
The TRLN Argon Rails Engine provides additional templates, styles, search builder behaviors, catalog controller overrides, and other features to bootstrap a Blacklight catalog for the TRLN shared catalog index.

## Usage

Default configurations can be changed in: `your_app/config/trln_argon_config.yml`

Sass variables and other styles may be overridden in: `your_app/assets/stylesheets/trln_argon.scss`

## Installation

Install Solr with our local customizations and index some data.

(Details forthcoming. This is a work in progress.)

Create a new Rails application:

```bash
$ rails new my_terrific_catalog
```

Install Blacklight and Argon, run the Blacklight and Argon generators, start Solr, and index some data.

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

## Customizing your application

### Basic Settings

The Argon engine will add a configuration file to customize your application. Copy the sample file to use it

```
cp config/local_env.yml.sample config/local_env.yml
```

You will need to change settings in this file so that features like record rollup and filtering to just your local collection will work as expected.

```
SOLR_URL: http://127.0.0.1:8983/solr/trln
LOCAL_INSTITUTION_CODE: unc
APPLICATION_NAME: TRLN Argon
PREFERRED_RECORDS: "unc, trln"
APPLY_LOCAL_FILTER_BY_DEFAULT: "true"
REFWORKS_URL: "http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url="
ROOT_URL: 'https://discovery.trln.org'
ARTICLE_SEARCH_URL: 'http://libproxy.lib.unc.edu/login?url=http://unc.summon.serialssolutions.com/search?s.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
CONTACT_URL: 'https://library.unc.edu/ask/'
```

### Changing field labels and other UI text.

Both Blacklight and the Argon engine use a translation files for many UI text elements. This makes it easy to change text that appears throughout the UI.

You can see the default Argon translations in [trln_argon.en.yml](https://github.com/trln/trln_argon/blob/master/config/locales/trln_argon.en.yml). You can override any of these values by adding your own translations to a locales file in your application, such as in config/locales/blacklight.en.yml.

### Changing blacklight configurations related to search, metadata display, and faceting.

The Argon engine sets a number of blacklight configurations to default settings so that your catalog will work out of the box. If you want to change the default number of records per page, change the order or selection of available facets, or change the order or selection of metadata to display on brief or full records, you will need to modify your application's CatalogController in app/controllers/catalog_controller.rb.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
