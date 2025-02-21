module TaxRates
  EU_COUNTRIES = %i[france germany italy].freeze # Some EU Countries
  def self.rate(country)
    case country
    when :spain then 0.21
    when :france then 0.20
    when :germany then 0.19
    when :italy then 0.20
    else 0
    end
  end

  def self.eu_country?(country)
    EU_COUNTRIES.include?(country)
  end
end

