module ShipmentsHelper
  def render_table(count, ship)
    content_tag :div, :class => 'cal_ship_1' do
      #content_tag :span, :class => 'cal_ship_small' do
			#	"[#{ship.loads} loads via #{ship.shipper.brief_name}]"
			#end
			content_tag :div, :class => 'cal_ship_large' do
				"#{ship.wine}"
		  end
     # content_tag :span, :class => 'cal_ship_small' do
		#		"#{ship.from_winery.name} to #{ship.to_winery.name}"
		#	end
    end
  end
end
