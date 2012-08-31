module Awestruct
  module Extensions
    class Buessli

      def initialize
      end

      def execute(site)
        site.buessli = BuessliHelper.new(site)
      end
    end
  end
end

class BuessliHelper
  def initialize(site)
    @site = site
  end

  def map(gpx="")
    html = "<p>"
    html += "<div class=\"map\" gpx=\""
    html += @site.base_url
    html += "/gpx/"
    html += gpx
    html += ".gpx"
    html += "\">\n"
    html += "</div></p>"
    return html
  end

  def album(album="")
    return @site.picasa.alben[album].get_picture_table
  end

end

