require "yui/compressor"
require_relative 'minifier'

module Pubba
  module Assets
    class YUIMinifier < Minifier
      def self.minify(folder, handler)
        compressor = get_compressor(handler)
        Dir.glob("#{folder}/*.*") do |file|
          contents = File.read(file)
          File.open(file, "w") {|f| f.write(compressor.compress(contents))}
        end
      end

      private

      def self.get_compressor(handler)
        case handler
          when :js then YUI::JavaScriptCompressor.new
          when :css then YUI::CssCompressor.new
          else raise ArgumentError, "minify handler must be one of [:js, :css]"
        end
      end
    end # YUIMinifier
  end # Assets
end # Pubba
