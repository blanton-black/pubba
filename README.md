# pubba

pubba is a Sinatra extension designed to help you manage your site. It uses [Sprockets](https://github.com/sstephenson/sprockets) for packaging assets and [R18n](http://r18n.rubyforge.org/) for internationalization/localization. I use R18n as a central location for default text, the internationalization functionality is a nice bonus in the event the application needs to move in that direction.

# Note

This extension is under heavy, heavy development and is subject to massive changes over the next week or so.

TODO:

* Support 3rd part script tags in pubba.yml
* Add support for media queries on style definitions. This will obviously change the current pubba.yml format.
* Remove requirement for placing of scripts/styles in subdirectories. For instance, the convention now is scripts would be in subdirs like javascripts/custom and javscripts/third-party. The only scripts/styles in the root dir are those generated by this extension.
* Compress the combined assets
* More tests!
* Improve documentation!

# Why?

There's really two main driving forces behind this extension: audit requirements and code organization.

If you've ever had to deal with an audit department, you understand some of the strict requirements that can be placed on releases. One of the main themes in audit is providing proof on what was released.

Any process that involves changing code between environments, even in an automated fashion, is great fodder for the audit machine. This extension makes sure the javascript and css you work with in development is the same as it will be in production.

This does the require the use of a cache bursting query parameter to be added to the url instead of the digest per asset approach. While the digest approach is much more accurate it complicates using a commit/tag to completely represent the deployment contents.

As mentioned, code organization is another focus of Pubba. The config file __pubba.yml__  uses the global section to clearly state which assets should be on all pages. In addition, when using R18n, Pubba gives you access through a single page object.


# Settings

More details on these later, but here are the configuration options:

**Note: __settings.root__ refers to \<ProjectRoot\>/app/**

### Location of the config file. REQUIRED
    set :pubba_config, File.join(settings.root, '..', 'config', 'pubba.yml')

### Location of the public_folder. REQUIRED
    set :public_folder, File.join(settings.root, '..', 'public')

### Location of the asset_folder. REQUIRED
    set :asset_folder, File.join(settings.root, 'assets')

### Asset handler. Defaults to [Sprockets](https://github.com/sstephenson/sprockets)
Right now there's only support for Sprockets, but leaving the option open for others.
    set :asset_handler, Sinatra::Pubba::Assets::SprocketsHandler

### Location of the [R18n](http://r18n.rubyforge.org/) folder. OPTIONAL
    set :r18n_folder, File.join(settings.root, 'i18n')

### Locale. Defaults to 'en'
    set :r18n_locale, 'en'



# How?

First things first, you'll want to install the gem:

    gem install pubba

Then you'll want to use it in your app like so:

    require 'sinatra/pubba'

    class App < Sinatra::Application
      # Settings as described above
      set :asset_folder, File.join(settings.root, 'assets')
      set :public_folder, File.join(settings.root, '..', 'public')
      set :r18n_folder, File.join(settings.root, 'i18n')

      set :pubba_config, File.join(settings.root, '..', 'config', 'pubba.yml')

      register Sinatra::Pubba
    end

Next up is creating the all important __pubba.yml__ config file:

    global:
      styles:
        - "custom/global"
      head_scripts:
        - "third-party/jquery-1.7.0.min"
      body_scripts:
        - "third-party/jquery.cookie"
        - "custom/autocomplete"
        - "custom/application"

    # Home page configuration
    home:
      styles:
        - "custom/home"

    # Search results page configuration
    search:
      styles:
        - "custom/search"

The config file is referencing the javascripts and stylesheets located in the `asset_folder`.

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
      @page = Sinatra::Pubba::Site.page('home')
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

Now you obviouslly need some helpers to make use of the definitions in __pubba.yml__, and here they are:

* `page_head_tags`
  * This helper emits the `link` and `script` tags with the contents defined in __pubba.yml__
* `page_body_tags`
  * This helper emits the `script` tag with the contents defined in __pubba.yml__. You would typically place this just before the `</body>` tag.
* `burst(url)`
  * This helper simply appends a cache bursting parameter named `aid` to the end of the url. In development mode the `aid` value is updated per request. The intent is to help with the particularly aggressive caching Google's Chrome browser likes to implement. In production mode, Pubba requires `ENV[ASSET_ID]` to be set and uses this for the `aid` value. I expect this to be tweaked as I get further into implementation.

Sample use:

    html
      head
        title = @page.title
        == page_head_tags
      body
        menu
          a href="/" = @page.home_link
        == page_body_tags

What you'll see when working with Pubba is that the files in your `asset_folder` are never referenced in your view. Even in development mode! The intent is that development mode is as close to production mode as possible. So, you are working with the same combined asset file you will be deploying.

# Acknowledgement

Huge thanks to my company, [Primedia](http://primedia.com) for encouraging open source contributions. This particular extension is obviously very new and hasn't hit a production site yet, but it will. I will post a list here as we migrate our applications from Rails to Sinatra.

# Contributors

I highly value contributions and will happily list all those who submit accepted pull requests.

