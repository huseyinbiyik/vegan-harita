module PlacesHelper
  def instagram_link(place)
    link_to('Instagram', place.instagram_url, target: '_blank') if place.instagram_url.present?
  end

  def facebook_link(place)
    link_to('Facebook', place.facebook_url, target: '_blank') if place.facebook_url.present?
  end

  def twitter_link(place)
    link_to('Twitter', place.twitter_url, target: '_blank') if place.twitter_url.present?
  end

  def web_link(place)
    link_to('Web', place.web_url, target: '_blank') if place.web_url.present?
  end

  def email_link(place)
    link_to('Email', "mailto:#{place.email}") if place.email.present?
  end

  def phone_link(place)
    link_to('Phone', "tel:#{place.phone}") if place.phone.present?
  end
end
