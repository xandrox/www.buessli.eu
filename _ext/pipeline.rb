
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new( '/blog', :posts )
  # extension Awestruct::Extensions::Indexifier.new
end
