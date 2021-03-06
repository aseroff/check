# frozen_string_literal: true

# Helper for user pages
module UserHelper
  def profile_picture(user, thumb = false)
    user.avatar.blank? && gravatar?(user.email) ? gravatar_url(user.email, (thumb ? 100 : 300)) : thumb ? user.avatar.thumb.url : user.avatar.medium.url
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
    gravatar = Digest::MD5.hexdigest(email).downcase
    "https://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
  end
end
