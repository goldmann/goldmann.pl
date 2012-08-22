class TagAtomizer
  def initialize(options = {})
    @options = {
        :tags => [],
        :atom_options => {}
    }.merge(options)

    if @options[:output_path].nil? or @options[:feed_title].nil?
      if @options[:tags].size > 1
        # We need to psecify both if we generate atom for multiple tags
        abort "Please specify :output_path and :feed_title options when generating feed for #{@options[:tags].join(', ')} tags. See _ext/pipeline.rb."
      else
        # Defaults for tag-specific atoms
        @options[:output_path] = "/#TAG#.atom" if @options[:output_path].nil?
        @options[:feed_title] = "Blog posts for #TAG# tag" if @options[:feed_title].nil?
      end
    end
  end

  def execute(site)
    return if @options[:tags].empty?

    pages = []

    site.posts_tags.each do |tag|
      if @options[:tags].include?(tag.to_s)
        if @options[:tags].size  == 1
          output_path = @options[:output_path].gsub("#TAG#", tag.to_s)
          feed_title = @options[:feed_title].gsub("#TAG#", tag.to_s)

          Awestruct::Extensions::Atomizer.new(tag.pages, output_path, @options[:atom_options].merge(:feed_title => feed_title)).execute(site)
        else
          pages << tag.pages
        end
      end
    end

    if @options[:tags].size > 1
      Awestruct::Extensions::Atomizer.new(pages.flatten.uniq, @options[:output_path], @options[:atom_options].merge(:feed_title => @options[:feed_title])).execute(site)
    end
  end
end

