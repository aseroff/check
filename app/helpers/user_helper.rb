module UserHelper

	def profile_picture(user, thumb = false)
		unless user.avatar?
			img = gravatar_url(user.email, (thumb ? 100 : 300)) if gravatar?(user.email)
		else
			img = (thumb ? user.avatar.thumb : user.avatar.medium)
		end
		img
	end

	def gravatar?(email)
    	gravatar_check = "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}.png?d=404"
    	uri = URI.parse(gravatar_check)
    	http = Net::HTTP.new(uri.host, uri.port)
    	request = Net::HTTP::Get.new(uri.request_uri)
    	response = http.request(request)
    	response.code.to_i != 404
	end

	def gravatar_url(email, size)
		gravatar = Digest::MD5::hexdigest(email).downcase
		url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
	end

end