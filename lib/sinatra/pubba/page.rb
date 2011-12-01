module Sinatra
  module Pubba
    class Page
      attr_accessor :name
      attr_reader :assets, :r18n

      def initialize(name, global_configuration = {})
        @name = name
        @assets = {}

        Site.asset_types.keys.each do |asset|
          @assets[asset] = global_configuration[asset] || []
        end
      end

      def add_asset(name, array)
        assets[name] += array unless array.empty?
      end

      def assetize
        Site.asset_types.each{ |key, val| create_asset(key, val) }
      end

      def method_missing(meth, *args)
        t.send(name).send(meth, *args)
      end

      private

      def process_scripts(array)
        return [] if array.nil? || array.empty?

        array.each{|ele| scripts << ele }
      end

      def create_asset(asset, dir)
        type = asset.split('_').first
        ext  = asset.end_with?('styles') ? 'css' : 'js'

        File.open( File.join(dir, "#{name}-#{type}.#{ext}"), 'w') do |f|
          f.write Site.disclaimer
          assets[asset].each do |script|
            f.write "//= require #{script}.#{ext}\n"
          end
        end
      end
    end # Page
  end # Pubba
end # Sinatra
