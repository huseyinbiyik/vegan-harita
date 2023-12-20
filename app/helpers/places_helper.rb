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

  def map_icons
    [
      asset_path('vegan-place.svg'),
      asset_path('vegan-friendly-place.svg'),
      asset_path('zoom-in.svg'),
      asset_path('zoom-out.svg'),
      asset_path('find-me.svg')
    ].to_json
  end
end
