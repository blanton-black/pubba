module Sinatra
  module Pubba
    module HTML
      module Helpers
        def page_head_tags
          tag_content('link', '', { href: burst("/stylesheets/#{@page.name}-styles.css"), rel: "stylesheet", type: "text/css" }) + tag_content('script', '', { src: burst("/javascripts/#{@page.name}-head.js"), type: "text/javascript" })
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
            %|#{k}="#{v}"|
          end.join(' ')
        end
      end
    end # HTML
  end # Pubba
end # Sinatra
