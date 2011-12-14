require 'fssm'

module Sinatra
  module Pubba
    module Monitor
      extend self

      def do
        start_monitor unless @running
      end

      def start_monitor
        @running = Thread.new do
          puts "Pubba is now monitoring: #{Site.asset_folder}"
          FSSM.monitor(Site.asset_folder, '**/*', :directories => true) do
            update {|base, relative, type| Site.process}
            delete {|base, relative, type| Site.process}
            create {|base, relative, type| Site.process}
          end
        end
      end
    end # Monitor
  end # Pubba
end # Sinatra
