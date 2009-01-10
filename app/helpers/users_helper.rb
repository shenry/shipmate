module UsersHelper
  def user_has_access_to(user)
    if user.access == 'Global'
			access = 'Unlimited'
		elsif user.access == 'Winery'
			access = user.wineries.collect {|w| w.name}.join(', ')
	  elsif user.access == 'Carrier'
			access = user.shipper.name
		else
			access = 'Unknown access type'
		end
		return access
  end
end
