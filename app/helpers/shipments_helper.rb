module ShipmentsHelper
  def render_table(count, ship)
    content_tag :div, :class => 'cal_ship_1' do
			content_tag :div, :class => 'cal_ship_large' do
				"#{ship.wine}"
		  end
    end
  end
end
