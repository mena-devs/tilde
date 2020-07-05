module CountryName
  include ActiveSupport::Concern

  def country_name(location)
    country = ISO3166::Country[location]
    if country
      return (country.translations[I18n.locale.to_s] || country.name)
    else
      "Not set"
    end
  end
end