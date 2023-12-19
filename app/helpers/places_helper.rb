module PlacesHelper
  def social_link_url(key, value)
    case key
    when 'instagram', 'facebook', 'x'
      "https://www.#{key}.com/#{value}"
    when 'web'
      "https://#{value}"
    when 'email'
      "mailto:#{value}"
    else
      value
    end
  end
end
