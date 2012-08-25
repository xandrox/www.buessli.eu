
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/blog', :posts )
  # extension Awestruct::Extensions::Paginator.new( :posts, '/blog/index', :per_page=>10 )
  # extension Awestruct::Extensions::Indexifier.new
end

