class Bugzilla
  def initialize(options = {})
    @options = {
        :base_url => 'https://bugzilla.redhat.com',
        :layout => 'UNDEFINED',
        :since => Time.utc(2012, 07, 01)
    }.merge(options)
  end

  def execute(site)
    site.pages.each do |page|
      next if @options[:layout] != page.layout or page.timestamp.nil?

      if page.is_a?(Awestruct::Handlers::MarkdownHandler) and @options[:since].nil? or page.timestamp > @options[:since]
        page.raw_content.gsub!(/RHBZ\#(\d+)/, "<a href=\"#{@options[:base_url]}/show_bug.cgi?id=\\1\">RHBZ#\\1</a>")
      end
    end
  end
end

