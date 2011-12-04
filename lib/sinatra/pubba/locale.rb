require 'r18n-desktop'

module Sinatra
  module Pubba
    class Locale
      include R18n::Helpers

      R18n.from_env Site.r18n_folder, Site.r18n_locale

      def get(category, name, *args)
        res = t.send(category).send(name, *args)
        res = t.send(name, *args) if R18n::Untranslated === res

        R18n::Untranslated === res ? nil : res
      end
    end # Locale
  end # Pubba
end # Sinatra
