module Sinatra
  module Pubba
    class AssetHandler
      def self.asset(file)
        raise NotImplementedError
      end

      def save_as(file)
        raise NotImplementedError
      end
    end
  end
end
