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

  def map_assets
    [
      asset_path('vegan-place.svg'),
      asset_path('vegan-friendly-place.svg'),
      asset_path('zoom-in.svg'),
      asset_path('zoom-out.svg'),
      asset_path('find-me.svg'),
      I18n.t('you_are_here'),
      I18n.t('location_not_found'),
      I18n.t('location_not_supported'),
    ].to_json
  end
end
