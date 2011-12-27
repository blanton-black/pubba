require 'fssm'

module Pubba
  module Monitor
    extend self

    def do
      start_monitor unless @running
    end

    def start_monitor
      @running = Thread.new do


        script_asset_folder = File.join(Site.asset_folder, Site.script_folder)
        style_asset_folder = File.join(Site.asset_folder, Site.style_folder)

        puts ">> Pubba is now monitoring:\n>>   #{script_asset_folder}\n>>   #{style_asset_folder}"
        FSSM.monitor do
          path script_asset_folder do
            glob '**/*'
            update {|base, relative, type| Site.process}
            delete {|base, relative, type| Site.process}
            create {|base, relative, type| Site.process}
          end

          path style_asset_folder do
            glob '**/*'
            update {|base, relative, type| Site.process}
            delete {|base, relative, type| Site.process}
            create {|base, relative, type| Site.process}
          end
        end
      end
    end
  end # Monitor
end # Pubba
