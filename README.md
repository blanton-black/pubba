# pubba

pubba is a Sinatra extension designed to help you manage your site. It uses [Sprockets](https://github.com/sstephenson/sprockets) for packaging assets and [R18n](http://r18n.rubyforge.org/) for internationalization/localization. I use R18n as a central location for default text, the internationalization functionality is a nice bonus in the event the application needs to move in that direction.

# Why?

There's really two main driving forces behind this extension: audit requirements and code organization.

If you've ever had to deal with an audit department, you understand some of the strict requirements that can be placed on releases. One of the main themes in audit is providing proof on what was released.

Any process that involves changing code between environments, even in an automated fashion, is great fodder for the audit machine. This extension makes sure the javascript and css you work with in development is the same as it will be in production.


