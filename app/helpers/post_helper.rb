module PostHelper

	def post_with_links(post)
		if post.text
  			post.text.gsub(/@\w+/).each do |username|
    			user = User.find_by_username(username[1..-1])
    			if user
      				link_to username, user
    			else
      				username
    			end
    		end
    	end
    end
    
end