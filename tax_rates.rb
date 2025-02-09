module TaxRates
  EU_COUNTRIES = %i[france germany italy].freeze # Some EU Countries
  def self.rate(country)
    case country
    when :spain then 0.20
    when *EU_COUNTRIES then 0.18
    else 0
    end
  end

  def self.eu_country?(country)
    EU_COUNTRIES.include?(country)
  end
end

