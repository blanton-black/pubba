module Sinatra
  module Pubba
    module HTML
      module Helpers
        def page_head_tags

          tags = @page.head_tags.collect do |hsh|
            if hsh[:tag] == "link"
              hsh[:rel] = "stylesheet"
              hsh[:type] = "text/css"
            else
              hsh[:type] = "text/javascript"
            end
            hsh
          end

          puts tags.inspect
          tags.collect do |tag|
            type = tag.delete(:tag)
            tag_content(type, '', tag)
          end
        end

        def page_body_tags
          tag_content('script', '', { src: burst("/javascripts/#{@page.name}-body.js"), type: "text/javascript" })
        end

        def burst(url)
          joiner = url.include?("?") ? "&" : "?"
          "#{url}#{joiner}aid=#{settings.asset_id}"
        end

        def tag_content(tag, content, attrs={}, self_closing=false)
          base = "<#{tag}#{tag_attrs(attrs)}"
          self_closing ? "#{base}/>":"#{base}>#{content}</#{tag}>"
        end

        def tag_attrs(attrs)
          return '' if attrs.empty?

          return " " + attrs.collect do |k,v|
            %|#{k}="#{v}"| unless v.nil?
          end.compact.join(' ')
        end
      end
    end # HTML
  end # Pubba
end # Sinatra
