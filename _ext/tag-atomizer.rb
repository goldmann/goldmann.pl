class TagAtomizer
  def initialize(options = {})
    @options = {
        :output_path => "/#TAG#.atom",
        :feed_title => "Blog posts for #TAG# tag",
        :tags => [],
        :atom_options => {}
    }.merge(options)
  end

  def execute(site)
    site.posts_tags.each do |tag|
      if @options[:tags].include?(tag.to_s) or @options[:tags].empty?
        output_path = @options[:output_path].gsub(/#TAG#/, tag.to_s)
        feed_title = @options[:feed_title].gsub(/#TAG#/, tag.to_s)

        Awestruct::Extensions::Atomizer.new(tag.pages, output_path, @options[:atom_options].merge(:feed_title => feed_title)).execute(site)
      end
    end
  end
end

