# TRLN Argon Rails Engine

## WIP for removal of blacklight advanced search plugin

This branch reflects work to remove the `blacklight_advanced_search` plugin
which does not fit well into Blacklight 7, which has its own way of providing
similar functionality.  It does not, as of 2022-05-26, work, since the
queries it builds are interpreted as requiring HTTP POST to the Solr service,
which is disabled for security reasons.  However, it illustrates many of 
the steps required to remove the plugin code and rely on the functionality built
in ot Blacklight 7.

It is based on the active `argon-2` branch during development of Argon 2


## THIS REPRESENTS WORK IN PROGRESS

We aim to keep this information up to date but the application is changing.

Ask in the Slack channel if anything is not working as documented here.


The TRLN Argon Rails Engine provides additional templates, styles, search
builder behaviors, catalog controller overrides, and other features to
bootstrap a Blacklight catalog for the TRLN shared catalog index.

# Developing

Since a Rails engine is not a complete application, We use [Engine
Cart](https://github.com/cbeer/engine_cart) to run a development instance.  To
run with `engine_cart`, clone this repository and change into the directory,
then run:

       $ bundle install
	   $ bundle exec rake engine_cart:prepare
       $ bundle exec rake engine_cart:server
       $ # if you already have something on port 3000 and want to use a different port
       $ bundle exec rake engine_cart:server['-p 3001']

The TRLN Argon Blacklight catalog should now be available at [http://localhost:3000](http://localhost:3000) (or a different port if you used the second form).

## Development With Docker

We are actively working on allowing development using containers, to allow quickly switching between Ruby versions without having to use Ruby version management software (e.g. RVM).  The key components here are the `Dockerfile`, `docker-compose.yml`, and `entrypoint.sh`.

### "Just" Docker

    $ docker build . -t trln_argon:latest
    $ docker run -v $(pwd):/app -p 3000:3000 trln_argon:latest

`-v` mounts the current directory into the container at `/app`; this allows you
to edit the files on the host and see the changes reflected in the container.

Note that this bind mount means that the `.internal_test_app` directory used by engine cart is also on the host system, and will persist between stop, starts, and rebuilds of the container. It's best to delete this directory after rebuilds and before fresh starts. Failure to do so can lead to inexplicable errors.

If `.internal_test_app` does not exist when the container is started, it will be created as the application is generated.

Special note for podman users: use `-v $(pwd):/app:Z` to make sure your bind
mount works with SELinux enabled.

### Using docker compose

The `docker-compose.yml` file automates a lot of the above for you.

    $ podman-compose build # builds the image
    $ podman-compose up # starts a container based on the image; output to terminal; ctrl-c to stop
    $ podman-compose down # removes the container

### `entrypoint.sh`

This does some startup magic, like removing PID files which are often not cleaned up when stopping containers.  It also bundles up various commands to automate common operations.  See the source of this file for more details.

### `bundler_config.rb` 

By default we're using Ruby 2.7 in the container but you may occasionally want
to switch this up to Ruby 2.6; since these versions of Ruby come with different
versions of bundler that use different syntax to set the path for installed
gems, this script must be copied into the container and its output executed in
order to portably set this path. It should not be needed outside this narrow
context.

## Creating a Rails Application using the TRLN Argon Engine.

This is what you want to do if you are intending to customize an application using the engine for a local catalog instance, it's not needed for development.

1. Create a new Rails application:

        $ rails new my_terrific_catalog

2. Install Blacklight and Argon, run the Blacklight and Argon generators.

Add the folliwing lines to your Gemfile:

```
gem 'blacklight', "~> 6.16"
gem 'trln_argon', git: 'https://github.com/trln/trln_argon'
```

3. Run the following:

        $ bundle install
        $ bundle exec rails generate blacklight:install --devise --skip-solr
        $ bundle exec rails generate trln_argon:install
        $ bundle exec rake db:migrate

At this point, you have a rails application with all the trln_argon stuff installed, and you can run it with

    $ bundle exec puma -d

### Running in 'production' mode for speed (but not really *for production*, mind you)

Running a Rails application in production mode has a number of benefits, one
being that the application is not constantly checking to see if parts of it
have changed, that it has less verbose logging, etc.  If you are demoing the
project, you might want to use this mode, but note this is not a guide to
putting this engine into production, because the illustrated process is
not really secure long-term.

So do this at your own risk!

1. Create a secret key to use

        $ python -c 'import hashlib; import os; dg=hashlib.sha256(); dg.update("this is my r4dical secret"); dg.update(os.urandom(24)); print(dg.hexdigest())'

2. Edit `./start.sh`, taking the output of the above command and setting it as the value of `SECRET_KEY_BASE`, being sure to wrap it in quotes.

3. Precompile the assets:

        $ bundle exec rake assets:precompile

4. Run the application

        $ ./start.sh

5. Set up a web server to proxy the application and serve static assets

e.g. in Apache

```
<VirtualHost *.80>
    ServerName my.argon.hostname
    DocumentRoot /path/to/argon/public
    ProxyRequests Off
    ProxyPass ! /assets
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
</VirtualHost>
```

Alternately, if you don't want to fiddle with Apache or NGINX,
[Caddy](https://caddyserver.com/) is a standalone web server that is available for a number of platforms; this project contains a `Caddyfile` that listens on port 8080 and do pretty much the above, i.e. serve assets out of `public/assets` and proxy everything else back to Rails.  If `caddy` is installed, you can just run it in the application directory, like so:

        $ caddy

## Code Mappings

Code mappings are handled by synchronizing a directory on the local filesystem
with the [argon_code_mappings](https://github.com/trln/argon_code_mappings)
repository.  By default, the repository will be checked out to the directory
`argon_mappings` under `config/mappings/` under the Rails root (.e.g.
`config/mappings/argon_mappings`).  If you don't like the idea of having
another git repository inside what might be the git repository containing your
application, you can set `ARGON_CODE_MAPPINGS_DIR` (in `local_env.yml`, see
below) to an appropriate value.

When running in production, the lookups generated from these files are loaded at application startup and
reloaded every 24 hours (which allows your application to pick up changes
coming in from other institutions without you having to intervene), but if you
have made a locally important change and you want to reload the mappings
immediately, you can execute the rake task `trln_argon:reload_code_mappings`.

This will sync your local copy with the upstream repository, and un-cache the
lookups generated from the files in the repository, meaning your changes will
be visible immediately in the running application.

    $ RAILS_ENV=production bundle exec rake trln_argon:reload_code_mappings

(this will fail unless you also have SECRET_KEY_BASE defined in your
environment; it doesn't need to be the actual value in use by the web
application for this purpose, however.)

When running in 'development' environment, the code mappings are loaded *once*
at startup, because Rails doesn't cache in this mode and otherwise would be
trying to pull changes down from github too often.  So, in this case, you'll
need to restart your application or run the above rake task with the
`development` environment if you want to have changes take effect.


## About the `trln_argon:install` generator task

You can see what the generator does in this file: [install_generator.rb](https://github.com/trln/trln_argon/blob/master/lib/generators/trln_argon/install_generator.rb)


## Customizing your application

### Basic Settings

The Argon engine will add a configuration file to customize your application.

```
config/local_env.yml
```

You will need to change settings in this file so that features like record rollup and filtering to just your local collection will work as expected.

```
SOLR_URL: http://127.0.0.1:8983/solr/trln
LOCAL_INSTITUTION_CODE: unc
APPLICATION_NAME: TRLN Argon
# Where the argon_code_mappings git repo is checked out.
ARGON_CODE_MAPPINGS_DIR: #{Rails.root.join('config', 'mappings')
REFWORKS_URL: "http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url="
ROOT_URL: 'https://discovery.trln.org'
ARTICLE_SEARCH_URL: 'http://libproxy.lib.unc.edu/login?url=http://unc.summon.serialssolutions.com/search?s.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
CONTACT_URL: 'https://library.unc.edu/ask/'
FEEDBACK_URL: ''
#Define the order of institutions in holding list. Your institution should go first.
SORT_ORDER_IN_HOLDING_LIST: 'unc, duke, ncsu, nccu, trln'
NUMBER_OF_LOCATION_FACETS: '10'
NUMBER_OF_ITEMS_INDEX_VIEW: '3'
NUMBER_OF_ITEMS_SHOW_VIEW: '6'
# Sets the last page of results that may be loaded.
# Deep paging is resource intensive and without this limit
# bots and humans can overload Solr. Configurable, but the default
# value is recommended.
PAGING_LIMIT: 250
# Sets the last page of facet results that may be loaded.
# Deep facet paging is resource intensive and without this limit
# bots and humans can overload Solr. Configurable, but the default
# value is recommended.
FACET_PAGING_LIMIT: 50
# this entry need not be present, but this shows the default
# value; a git repository containing the mappings is checked
# out to the directory
ARGON_CODE_MAPPINGS_DIR: #{File.join(Rails.root, 'config', 'mappings')

# The following are collectively required to perform queries
# against the Worldcat API and link to the results, which is typically
# done when there are no results.

# Wording and styling of the results can be adjusted via editing the
# key `trln_argon.search.zero_results.{worldcat_href, worldcat_html}`
# in the locale file and/or editing  the
# `app/views/catalog/_zero_results.html.erb` template

WORLDCAT_URL: # URL for localized instance of Worldcat
WORLDCAT_API_URL: # https://www.worldcat.org/webservices/catalog/search/sru
WORLDCAT_API_KEY: # (institution-specific key for accessing above API)
```

### Changing Styles

Override Argon default Sass Variables by modifying values in the following file that is generated by the Argon gem into your local application:
`app/assets/stylesheets/trln_argon_variables.scss`

Default Argon variable settings can be found in the following file in the Argon gem:
`app/assets/stylesheets/trln_argon_variables_defaults.scss`

To override other styles from the gem make changes after the import statements in:
`app/assets/stylesheets/trln_argon.scss`

### Changing field labels and other UI text.

Both Blacklight and the Argon engine use a translation files for many UI text
elements. This makes it easy to change text that appears throughout the UI.

You can see the default Argon translations in
[trln_argon.en.yml](https://github.com/trln/trln_argon/blob/master/config/locales/trln_argon.en.yml).
You can override any of these values by adding your own translations to a
locales file in your application, such as in config/locales/blacklight.en.yml.

You can change labels used for display of metadata fields in `config/solr_field_overrides.yml`

### Changing blacklight configurations related to search, metadata display, and faceting.

The Argon engine sets a number of blacklight configurations to default settings
so that your catalog will work out of the box. If you want to change the
default number of records per page, change the order or selection of available
facets, or change the order or selection of metadata to display on brief or
full records, you will need to modify your application's CatalogController in
app/controllers/catalog_controller.rb.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
