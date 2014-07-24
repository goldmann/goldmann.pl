class TagAtomizer
  def initialize(tags, options = {})
    @options = options
    @tags = tags

    if @options[:output_path].nil? or @options[:feed_title].nil?
      if @tags.size > 1
        # We need to psecify both if we generate atom for multiple tags
        abort "Please specify :output_path and :feed_title options when generating feed for #{@tags.join(', ')} tags. See _ext/pipeline.rb."
      else
        # Defaults for tag-specific atoms
        @options[:output_path] = "/#TAG#.atom" if @options[:output_path].nil?
        @options[:feed_title] = "Blog posts for #TAG# tag" if @options[:feed_title].nil?
      end
    end
  end

  def execute(site)
    return if @tags.empty?

    pages = []

    site.posts_tags.uniq.each do |tag|
      if @tags.include?(tag.to_s)
        if @tags.size  == 1
          output_path = @options[:output_path].gsub("#TAG#", tag.to_s)
          feed_title = @options[:feed_title].gsub("#TAG#", tag.to_s)

          Awestruct::Extensions::Atomizer.new(tag.pages, output_path, @options.merge(:feed_title => feed_title)).execute(site)
        else
          pages << tag.pages
        end
      end
    end

    if @tags.size > 1
      tagged_pages = pages.flatten.uniq

      tagged_pages.sort! do |x,y|
        x_date = DateTime.parse((x[:updated] || x[:timestamp]).to_s)
        y_date = DateTime.parse((y[:updated] || y[:timestamp]).to_s)

        x_date <=> y_date
      end

      Awestruct::Extensions::Atomizer.new(tagged_pages.reverse, @options[:output_path], @options.merge(:feed_title => @options[:feed_title])).execute(site)
    end
  end
end

