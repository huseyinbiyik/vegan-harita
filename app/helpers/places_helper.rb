module PlacesHelper
  def social_link_url(key, value)
    case key
    when "instagram", "facebook", "x"
      "https://www.#{key}.com/#{value}"
    when "web"
      "https://#{value}"
    when "email"
      "mailto:#{value}"
    else
      value
    end
  end

  def map_assets
    [
      asset_path("vegan-place.svg"), # 0
      asset_path("vegan-friendly-place.svg"), # 1
      asset_path("zoom-in.svg"), # 2
      asset_path("zoom-out.svg"), # 3
      asset_path("find-me.svg"), # 4
      I18n.t("you_are_here"), # 5
      I18n.t("location_not_found"), # 6
      I18n.t("location_not_supported"), # 7
      I18n.t("open"), # 8
      I18n.t("closed"), # 9
      asset_path("status.svg") # 10
    ].to_json
  end
end
