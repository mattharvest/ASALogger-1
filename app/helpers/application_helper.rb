module ApplicationHelper

	def title
		base_title="ASA Logger, Prince George's County"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
	
	def logo
		image_tag("logo.jpg", :alt=>"asaLogger", :class=>"round")
	end
	
end
