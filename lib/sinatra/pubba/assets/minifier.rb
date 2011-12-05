module Sinatra
  module Pubba
    module Assets
      class Minifier
        def self.minify(folder, handler)
          raise NotImplementedError
        end

        def self.get_compressor(handler)
          raise NotImplementedError
        end
      end # Compressor
    end # Assets
  end # Pubba
end # Sinatra
