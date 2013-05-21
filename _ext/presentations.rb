require 'fileutils'

class Presentations
  def initialize(options = {})
    @options = {
        :output_dir => 'presentations',
        :presentations_dir => '.presentations'
    }.merge(options)
  end

  def execute(site)
    FileUtils.cp_r(@options[:presentations_dir], "#{site.config.output_dir}/#{@options[:output_dir]}")
  end
end


