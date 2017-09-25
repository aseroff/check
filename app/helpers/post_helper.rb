module PostHelper

	def post_with_links(post, amp = false)
		if post.text
  			post.text.gsub(/@\w+/).each do |username|
    			user = User.where('lower(username) = ?', username[1..-1].downcase).first
    			if user
      				Relation.find_or_create_by(user_id: user.id, relationship: "mention", related_id: post.id)
      				amp ? (link_to username, user_path(user, format: :amp)) : (link_to username, user)
    			else
      				username
    			end
    		end
    	end
    end

end