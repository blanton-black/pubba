require 'r18n-desktop'

module Pubba
  class Locale
    include R18n::Helpers

    R18n.from_env Pubba.r18n_folder, Pubba.r18n_locale

    def get(category, name, *args)
      res = t.send(category).send(name, *args)
      res = t.send(name, *args) if R18n::Untranslated === res

      R18n::Untranslated === res ? nil : res
    end
  end # Locale
end # Pubba
