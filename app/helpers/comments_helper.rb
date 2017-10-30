module CommentsHelper

def comment_with_links(comment, amp = false)
	if comment.text
  		comment.text.gsub(/@\w+/).each { |username|
    		user = User.where('lower(username) = ?', username[1..-1].downcase).first
  			if user
   				amp ? (link_to username, user_path(user, format: :amp)) : (link_to username, user)
   			else
  				username
  			end
   		}
  	end
end

end
