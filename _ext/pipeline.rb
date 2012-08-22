require 'tag-atomizer'
require 'bugzilla'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new('/blog')
  extension Awestruct::Extensions::Paginator.new(:posts, '/blog/index', :per_page => 3)
  extension Awestruct::Extensions::Indexifier.new
  extension Awestruct::Extensions::IntenseDebate.new

  extension Awestruct::Extensions::Tagger.new(:posts,
                                              '/blog/index',
                                              '/blog/tags',
                                              :per_page=>5)

  extension Awestruct::Extensions::TagCloud.new(:posts,
                                                '/blog/tags/index.html',
                                                :layout=>'base')
  extension Awestruct::Extensions::Atomizer.new(:posts, '/blog.atom', :feed_title => "Blog posts")
  extension TagAtomizer.new(:tags => ['fedora'])
  extension TagAtomizer.new(:tags => ['jboss_as', 'java', 'jboss'], :output_path => "/jboss.atom", :feed_title => "Blog posts related to JBoss")
  extension Bugzilla.new(:layout => 'blog')

  helper Awestruct::Extensions::GoogleAnalytics
end

