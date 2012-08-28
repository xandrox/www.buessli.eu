# -*- coding: undecided -*-
require 'rexml/document'
require 'date'
require 'fileutils'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module Awestruct
  module Extensions
    class Picasa

      def initialize(output_base_path='picasa_cache/')
        puts "Picasa Init"
        @output_base_path = output_base_path
      end

      def execute(site)
        @site = site
        @site.picasa = {}
        @site.picasa.alben = {}
        rebuild_cache()
        File.open( "picasa.json", 'wb' ) do |f|
          f.write @site.picasa.to_json
        end
      end

      private

      def rebuild_cache()
        handle_user("https://picasaweb.google.com/data/feed/base/user/115799352095294636731?alt=rss&hl=de&imgmax=100")
      end

      def handle_user(user_url)
        output_file = user_url.gsub(/https:\/\/picasaweb.google.com\/data\/feed\/base\//, @output_base_path)
        output_file = output_file.gsub(/\?.*/, "")
        output_file = output_file + ".xml"
        body = cache_file(user_url, output_file)
        doc = REXML::Document.new( body )
        root = doc.root
        root.get_elements( 'channel/item/guid' ).each do |item|
          handle_album(item.text) 
        end
      end
      
      def handle_album(album_url)
        album_url = album_url + "&imgmax=100"
        album_url = album_url.gsub(/\/entry\//, "/feed/")
        album_url = album_url.gsub(/\/photoid.*\?/, "?")
        output_file = album_url.gsub(/https:\/\/picasaweb.google.com\/data\/feed\/base\//, @output_base_path)
        output_file = output_file.gsub(/\?.*/, "")
        output_file = output_file + ".xml"
        body = cache_file(album_url, output_file)
        doc = REXML::Document.new( body )
        root = doc.root
        album_title = root.get_elements( 'channel/title' )[0].text
        pictures = []
        size = "s220-c"
        if ( album_title =~ /panorama/ )
          size = "s1200"
        end
        root.get_elements( 'channel/item' ).each do |item|
          pictures.push(handle_picture(item, size))
        end
        @site.picasa.alben[album_title] = PicasaAlbum.new(album_title)
        @site.picasa.alben[album_title].pictures = pictures
        @site.picasa.alben[album_title].link = root.get_elements("channel/link")[0].text
      end
      
      def handle_picture(picture_item, size)
        picture = {}
        url = picture_item.get_elements("media:group/media:content")[0].attributes["url"]
        url = url.gsub(/s100-c/, "s100")
        picture["url"] = url.gsub(/s100/, size)
        picture["link"] = picture_item.get_elements("link")[0].text
        return picture
      end
      
      def cache_file(url_to_get, output_file)
        body = "";
        if ( ! File.exist?( output_file ) )
          FileUtils.mkdir_p( File.dirname( output_file ) )
          body = get_url( url_to_get )
          File.open( output_file, 'wb' ) do |f|
            f.write body
          end
        else
          file = File.new( output_file , "r")
          while (line = file.gets)
            body += line
          end
          file.close
        end
        return body
      end
      
      def get_url(url_to_get)
        puts "GET " + url_to_get
        url = URI.parse( url_to_get )
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = trueg
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(url.request_uri)
        res = http.start {|http| http.request(request) }
        return res.body
      end
      
    end

  end

end

class PicasaAlbum
  
  attr :pictures, true
  attr :link, true

  def initialize(name="default")
    @name = name
  end

  def get_picture_table(cell_one=1, cell_two=2, cell_three=3, cell_four=4)
    html = "<table class=\"picasa_pictures\" data-title=\"" + @name + "\">"
    html += "<tr>"
    html += get_picture_cell(self.pictures[cell_one - 1 ])
    html += get_picture_cell(self.pictures[cell_two - 1])
    html += get_picture_cell(self.pictures[cell_three - 1])
    html += get_picture_cell(self.pictures[cell_four - 1])
    html += "</tr>"
    html += "</table>"
    html += "<p><center>"
    html += "<a href=\"" + self.link + "\">"
    html += "[alle Bilder anzeigen]</a>"
    html += "</center></p>"
    return html
  end

  def get_picture_cell(picture)
    html = "<td>"
    if (picture != nil)
      html += "<center>"
      html += "<a href=\"" + picture["link"] + "\">"
      html += "<img src=\"" + picture["url"] + "\">"
      html += "</a>"
      html += "</center>"
    end
    html += "</td>"
    return html
  end

  def to_json(*a)
    {
      'json_class'   => self.class.name,
      'data'         => [ link, pictures ]
    }.to_json(*a)
  end
  
  def self.json_create(o)
    new(*o['data'])
  end
end
