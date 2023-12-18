module PlacesHelper
  def instagram_link(place)
    link_to('Instagram', place.instagram_handle, target: '_blank') if place.instagram_handle.present?
  end

  def facebook_link(place)
    link_to('Facebook', place.facebook_handle, target: '_blank') if place.facebook_handle.present?
  end

  def twitter_link(place)
    link_to('Twitter', place.x_handle, target: '_blank') if place.x_handle.present?
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
