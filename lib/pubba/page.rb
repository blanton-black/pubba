module Pubba
  class Page
    attr_accessor :name
    attr_reader :assets, :head_tags, :body_tags

    def initialize(name, global_configuration = {})
      @name = name
      @assets = {"styles" => {}, "scripts" => {}}
      @head_tags = []
      @body_tags = []

      global_configuration["styles"].each do |key, value|
          @assets["styles"][key] = value.dup
      end

      script_groups do |group|
        @assets["scripts"][group] = global_configuration["scripts"][group] || []
      end
    end

    def add_asset(type, section)
      if type == "styles"
         section.each do |section_name, hash|
           hash.each do |key, value|
            if key == "urls"
              @assets[type][section_name][key] += value
            else
              @assets[type][section_name][key] = value
            end
          end
        end
      else
        script_groups do |group|
          @assets["scripts"][group] += section[group] if section[group]
        end
      end
    end

    def assetize
      create_style_assets
      create_script_assets
    end

    def tagify
      style_groups do |group, hash|
        style_urls(group) do |url|
          add_style_tag(group, hash, url)
        end
      end

      script_groups do |group|
        script_urls(group) do |url|
          add_script_tag(group, url)
        end
      end
    end

    def method_missing(meth, *args)
      if Site.locale && (t = Site.locale.get(name, meth, *args))
        return t
      end
      super
    end

    private

    def process_scripts(array)
      return [] if array.nil? || array.empty?

      array.each{|ele| scripts << ele }
    end

    def create_style_assets
      style_groups do |group, hash|
        urls = []
        style_urls(group) do |url|
          next if url.start_with?("http")
          urls << url
        end
        Site.asset_handler.build(name, group, "css", urls)
      end
    end

    def create_script_assets
      script_groups do |group|
        urls = []
        script_urls(group) do |url|
          next if url.start_with?("http")
          urls << url
        end
        Site.asset_handler.build(name, group, "js", urls)
      end
    end

    def style_groups
      @assets["styles"].each{|group, hash| yield group, hash }
    end

    def style_urls(group)
      @assets["styles"][group]["urls"].each{|url| yield url }
    end

    def script_groups
      ["head", "body"].each{|group| yield group }
    end

    def script_urls(group)
      @assets["scripts"][group].each{|url| yield url }
    end

    def add_style_tag(group, hash, url)
      h = { tag: 'link', type: 'text/css', rel: 'stylesheet' }
      h[:media] = hash['media'] if hash['media']
      h[:href]  = url.start_with?("http") ? url : "/#{Pubba.style_folder}/#{name}-#{group}.css"

      maybe_add_tag(@head_tags, h, :href)
    end

    def add_script_tag(group, url)
      h = { tag: 'script', type: "text/javascript" }
      h[:src]   = url.start_with?("http") ? url : "/#{Pubba.script_folder}/#{name}-#{group}.js"

      tag_set = (group == "head") ? @head_tags : @body_tags
      maybe_add_tag(tag_set, h, :src)
    end

    def maybe_add_tag(tag_set, hash, key)
      found = false
      tag_set.each{|tag| found = true if tag[key] == hash[key]}
      tag_set << hash unless found
    end
  end # Page
end # Pubba
