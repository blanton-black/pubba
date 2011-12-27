module Pubba
  module Assets
    class Handler
      def self.asset(file)
        raise NotImplementedError
      end

      def save_as(file)
        raise NotImplementedError
      end

      def process(pattern, destination)
        raise NotImplementedError
      end

      def build(name, type, ext, urls)
        raise NotImplementedError
      end
    end # Handler
  end # Assets
end # Pubba
