
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/blog', :posts )
#  extension Awestruct::Extensions::Tagger.new( :posts, '/blog/index', '/blog/tags', :per_page=>10, :sanitize=>true )
#  extension Awestruct::Extensions::TagCloud.new(:posts, '/blog/tags/index.html', :layout=>'tab', :title=>'Tags')
  # extension Awestruct::Extensions::Paginator.new( :posts, '/blog/index', :per_page=>10 )
  # extension Awestruct::Extensions::Indexifier.new
end

