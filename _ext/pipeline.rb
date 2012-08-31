require 'picasa'
require 'buessli'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Picasa.new
  extension Awestruct::Extensions::Posts.new( '/europareise2012', :europareise2012s )
  extension Awestruct::Extensions::Posts.new( '/busausbau', :busausbaus )
  extension Awestruct::Extensions::Buessli.new
  extension Awestruct::Extensions::Atomizer.new( 
    :europareise2012s, 
    '/europareise2012/feed.atom', 
    :num_entries=>10000,
    :content_url=>'https://www.buessli.eu/europareise2012',
    :feed_title=> 'No Relation To' )
end

