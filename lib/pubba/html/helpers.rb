module Pubba
  module HTML
    module Helpers
      def page_head_tags
        process_tags(@page.head_tags)
      end

      def page_body_tags
        process_tags(@page.body_tags)
      end

      def digest_url(url)
        url.start_with?('http') ? url : Site.asset_host[::Statica.digest_url(url)]
      end

      private

      def process_tags(tags)
        array = []
        tags.each do |tag|
          t = tag.dup
          set_url(type = t.delete(:tag), t)
          array << tag_content(type, '', t)
        end
        array.join('')
      end

      def set_url(type, t)
        if type == 'script'
          t[:src] = digest_url(t[:src])
        else
          t[:href] = digest_url(t[:href])
        end
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
