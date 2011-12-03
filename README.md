# pubba

pubba is a Sinatra extension designed to help you manage your site. It uses [Sprockets](https://github.com/sstephenson/sprockets) for packaging assets and [R18n](http://r18n.rubyforge.org/) for internationalization/localization. I use R18n as a central location for default text, the internationalization functionality is a nice bonus in the event the application needs to move in that direction.

# Why?

There's really two main driving forces behind this extension: audit requirements and code organization.

If you've ever had to deal with an audit department, you understand some of the strict requirements that can be placed on releases. One of the main themes in audit is providing proof on what was released.

Any process that involves changing code between environments, even in an automated fashion, is great fodder for the audit machine. This extension makes sure the javascript and css you work with in development is the same as it will be in production.

# Settings

More details on these later, but here are the configuration options:

**Note: `settings.root` refers to \<ProjectRoot\>/app/**

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

First you need to have a config file, it's location should be set in the pubba_config setting:

    set :pubba_config, File.join(settings.root, '..', 'config', 'pubba.yml')

Here's an example file:

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

The config file is referencing the javascripts and stylesheets folders located in the asset_folder, which you need to set by:

    set :asset_folder, File.join(settings.root, 'assets')








