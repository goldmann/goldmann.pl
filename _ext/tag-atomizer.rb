class TagAtomizer
  def initialize(entries_name, options = {})
    @entries_name = entries_name
    @options = {
        :tags => []
    }.merge(options)
  end

  def execute(site)
    atoms = {}

    site.posts_tags.each do |tag|
      if @options[:tags].include?(tag.to_s) or @options[:tags].empty?
        site.send( "#{@entries_name}_#{tag.to_s}=", tag.pages )
        Awestruct::Extensions::Atomizer.new("#{@entries_name}_#{tag.to_s}".to_sym, "/#{tag.to_s}.atom").execute(site)
      end
    end
  end
end

