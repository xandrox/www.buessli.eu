require 'picasa'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Picasa.new
  extension Awestruct::Extensions::Posts.new( '/europareise2012', :europareise2012s )
  extension Awestruct::Extensions::Posts.new( '/busausbau', :busausbaus )
end

