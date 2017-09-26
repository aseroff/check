module PostHelper
  include Rails.application.routes.url_helpers

	def post_with_links(post, amp = false)
		if post.text
  		post.text.gsub(/@\w+/).each { |username|
    		user = User.where('lower(username) = ?', username[1..-1].downcase).first
  			if user
  				Relation.find_or_create_by(user_id: user.id, relationship: "mention", related_id: post.id)
   				amp ? (link_to username, user_path(user, format: :amp)) : (link_to username, user)
   			else
  				username
  			end
   		}.gsub(
/(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/i).each do |hashtag|
        term = hashtag.split("#").last
        amp ? (link_to hashtag, posts_path(term: term, format: :amp)) : (link_to hashtag, posts_path(term: term))
      end
  	end
  end

end