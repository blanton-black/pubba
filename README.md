# pubba

pubba is a library designed to help you manage your site. It uses [Sprockets](https://github.com/sstephenson/sprockets) for packaging assets and [R18n](http://r18n.rubyforge.org/) for internationalization/localization. I use R18n as a central location for default text, the internationalization functionality is a nice bonus in the event the application needs to move in that direction.

# Note

This extension is under heavy, heavy development and is subject to massive changes over the next week or so.

__I do not consider this project production ready at this time. It will be soon though.__

TODO:

* More tests!
* Improve documentation!

# Why?

There's really two main driving forces behind this extension: audit requirements and code organization.

If you've ever had to deal with an audit department, you understand some of the strict requirements that can be placed on releases. One of the main themes in audit is providing proof on what was released.

Any process that involves changing code between environments, even in an automated fashion, is great fodder for the audit machine. This extension makes sure the javascript and css you work with in development is the same as it will be in production.

As mentioned, code organization is another focus of pubba. The config file __pubba.yml__  uses the global section to clearly state which assets should be on all pages. This functionality is not restricted to your local assets. The pubba config file also allows you to declare external assets. In short, you should not have a single script tag in your views other than those generated by the `page_head_tags` and `page_body_tags` helpers provided by pubba.


In addition, when using R18n, pubba gives you access through a single page object. This allows you to have all your static text in a central location.


# Settings

More details on these later, but here are the configuration options:

### A couple of things to note:

* __settings.root__ refers to &lt;ProjectRoot&gt;/app/**
* Images are not processed and should be stored in your public directory


### Sample configuration
    Pubba.configure do |p|
      # REQUIRED.
      p.config_file   = File.join( File.dirname(__FILE__), 'pubba.yml')

      # REQUIRED.
      p.asset_folder  = File.join(settings.root, 'assets')

      # REQUIRED.
      p.public_folder = settings.public_folder

      # OPTIONAL. Defaults to 'css'
      p.style_folder = 'css'

      # OPTIONAL. Defaults to 'js'
      p.script_folder = 'js'

      # OPTIONAL. Defaults to Sprockets: https://github.com/sstephenson/sprockets/
      p.asset_handler = Pubba::Assets::SprocketsHandler

      # OPTIONAL. Defaults to YUI Compressor: https://github.com/sstephenson/ruby-yui-compressor/
      p.asset_minifier = Pubba::Assets::YUIMinifier

      # OPTIONAL. Asset hosts (value must be a Proc)
      p.asset_host = -> asset { [  "http://assets.mysite.com#{asset}",
                                   "http://assets1.mysite.com#{asset}"].sample }

      # OPTIONAL.
      p.r18n_folder   = File.join(settings.root, 'i18n')

      # OPTIONAL.
      p.r18n_locale, 'en'
    end



# How?

First things first, you'll want to install the gem:

    gem install pubba

Then you'll want to use it in your app like so:

    require 'sinatra/pubba'

    class App < Sinatra::Application
      # Settings as described above
      set :public_folder, File.join(settings.root, '..', 'public')

      Pubba.configure do |p|
        p.config_file   = File.join(settings.root, '..', 'config', 'pubba.yml')
        p.public_folder = settings.public_folder
        p.asset_folder  = File.join(settings.root, 'assets')
        p.r18n_folder   = File.join(settings.root, 'i18n')
      end
    end

Next up is creating the all important __pubba.yml__ config file:

    global:
      styles:
        all:
          urls:
            - "http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css"
            - "custom/global"
        phone:
          media: "only screen and (min-width: 480px)"
          urls:
            - "custom/large"
        desktop:
          media: "only screen and (max-width: 480px)"
          urls:
            - "custom/small"
      scripts:
        head:
          - "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"
          - "third-party/modernizr"
        body:
          - "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"
          - "third-party/backbone"
          - "custom/app"
          - "custom/tracker"

    # Home page configuration
    home:
      styles:
        all:
          urls:
            - "custom/home"

    # Search results page configuration
    search:
      styles:
        all:
          urls:
            - "custom/search"
      scripts:
        body:
          - "custom/lightbox"


The config file is referencing the javascripts and stylesheets located in the `asset_folder`. The default folder structure for assets:

    # Javascript assets
    {asset_folder}/js/

    # Stylesheet assets
    {asset_folder}/css/

    # After processing javascripts will be placed in:
    {public_folder}/js/

    # After processing stylesheets will be placed in:
    {public_folder}/css/


Now you obviouslly need some helpers to make use of the definitions in __pubba.yml__, and here they are:

* `page_head_tags`
  * This helper emits the `link` and `script` tags with the contents defined in __pubba.yml__
* `page_body_tags`
  * This helper emits the `script` tag with the contents defined in __pubba.yml__. You would typically place this just before the `</body>` tag.

Sample use:

    html
      head
        title = @page.title
        == page_head_tags
      body
        menu
          a href="/" = @page.home_link
        == page_body_tags

What you'll see when working with pubba is that the files in your `asset_folder` are never referenced in your view. Even in development mode! The intent is that development mode is as close to production mode as possible. So, you are working with the same combined asset file you will be deploying.

Using the above __pubba.yml__ configuration, if you are using the 'home' page definition, the output of `page_head_tags` will be (formatted for the README):

    <link href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css" rel="stylesheet" type="text/css"></link>
    <link href="/css/home-all.css" rel="stylesheet" type="text/css"></link>
    <link href="/css/home-phone.css" media="only screen and (max-width: 480px)" rel="stylesheet" type="text/css"></link>
    <link href="/css/home-desktop.css" media="only screen and (min-width: 480px)" rel="stylesheet" type="text/css"></link>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="/js/home-head.js" type="text/javascript"></script>|

Again, using the above __pubba.yml__ configuration, if you are using the 'home' page definition, the output of `page_body_tags` will be (formatted for the README):

    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js" type="text/javascript"></script>
    <script src="/js/home-body.js" type="text/javascript"></script>

# Monitoring changes

To monitor your assets directory to keep the public directory in sync, you'll need to create a rake task:

    namespace :pubba do
      desc 'Process the js and css assets then monitor for changes'
      task :monitor do

        # Require your app to configure Pubba
        require_relative 'app/app'

        require 'pubba/monitor'

        # The monitor process will only run Site.process when it detects a
        # change so we need to run it once to make sure the public directory
        # is in sync.

        puts ">> Processing assets..."
        Pubba::Site.process

        Pubba::Monitor.run
      end
    end

# R18n

If you're using R18n, you will need a translation file, here's a sample en.yml:

    home:
      title: "Home title"
      meta_description: "Home meta description"
      meta_keywords: "Home keywords"
      welcome_text: "Welcome Home"

    logout_link: "Logout"
    login_link: "Login"
    home_link: "Home"
    account_link: "My Account"

Take note of the __home__ section in both __pubba.yml__ and __en.yml__. If you have a route in your app that you want to use the __home__ defintions, do this:

    get '/' do
      @page = Pubba::Site.page('home')
      slim :"aux/index"
    end

The `@page` variable gives you access to the definitions in __en.yml__. In your view you'll be able to use it like so:

    html
      head
        title = @page.title
      body
        menu
          a href="/" = @page.home_link

Notice that `title` is defined under the `home` section, but `home_link` is a top level definition. Pubba makes the effort to correctly resolve the __en.yml__ reference for you. Nice isn't it.

# Acknowledgement

Huge thanks to my company, [Primedia](http://primedia.com) for encouraging open source contributions.

# Contributors

I highly value contributions and will happily list all those who submit accepted pull requests.

