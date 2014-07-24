require 'tag-atomizer'
require 'bugzilla'
require 'presentations'
require 'abstract'
require 'disqus'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new('/blog')
  extension Awestruct::Extensions::Paginator.new(:posts, '/blog/index', :per_page => 5)
  extension Awestruct::Extensions::Indexifier.new
  extension Disqus.new

  extension Awestruct::Extensions::Tagger.new(:posts,
                                              '/blog/index',
                                              '/blog/tags',
                                              :per_page=>5)

  extension Awestruct::Extensions::TagCloud.new(:posts,
                                                '/blog/tags/index.html',
                                                :layout=>'base')
  extension Awestruct::Extensions::Atomizer.new(:posts, '/blog.atom', :feed_title => "Blog posts", :template => File.join( File.dirname(__FILE__), 'template.atom.haml' ))
  extension TagAtomizer.new(['fedora'], :template => File.join( File.dirname(__FILE__), 'template.atom.haml' ) )
  extension TagAtomizer.new(['jboss_as', 'java', 'jboss'], :output_path => "/jboss.atom", :feed_title => "Blog posts related to JBoss", :template => File.join( File.dirname(__FILE__), 'template.atom.haml' ) )
  extension Bugzilla.new(:layout => 'blog')
  extension Presentations.new

  helper Awestruct::Extensions::GoogleAnalytics
end

