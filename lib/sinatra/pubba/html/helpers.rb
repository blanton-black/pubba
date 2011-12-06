module Sinatra
  module Pubba
    module HTML
      module Helpers
        def page_head_tags
          tags = []
          @page.head_tags.each do |tag|
            t = tag.dup
            type = t.delete(:tag)
            tags << tag_content(type, '', t)
          end
          tags.join('')
        end

        def page_body_tags
          tags = []
          @page.body_tags.dup.each do |tag|
            t = tag.dup
            type = t.delete(:tag)
            tags << tag_content(type, '', t)
          end
          tags.join('')
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
