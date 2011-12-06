module Sinatra
  module Pubba
    module HTML
      module Helpers
        def page_head_tags
          @page.head_tags.collect do |tag|
            type = tag.delete(:tag)
            tag_content(type, '', tag)
          end
        end

        def page_body_tags
          @page.body_tags.collect do |tag|
            type = tag.delete(:tag)
            tag_content(type, '', tag)
          end
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

          return " " + attrs.keys.sort.collect do |k|
            %|#{k}="#{attrs[k]}"|
          end.join(' ')
        end
      end
    end # HTML
  end # Pubba
end # Sinatra
