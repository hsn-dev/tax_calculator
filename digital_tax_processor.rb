class DigitalTaxProcessor
  def initialize(user_location, user_type)
    @user_location = user_location
    @user_type = user_type
    validate!
  end

  def calculate
    if @user_location == :spain
      { tax_rate: TaxRates.rate(@user_location), transaction_type: 'service, digital' }
    elsif TaxRates.eu_country?(@user_location)
      if @user_type == :individual
        { tax_rate: TaxRates.rate(@user_location), transaction_type: 'service, digital' }
      else
        { tax_rate: 0, transaction_type: 'reverse charge' }
      end
    else
      { tax_rate: 0, transaction_type: 'service, digital' }
    end
  end

  def validate!
    raise ArgumentError, 'user_location is required' if @user_location.nil?
    raise ArgumentError, 'user_type is required' if @user_type.nil?
  end
end

