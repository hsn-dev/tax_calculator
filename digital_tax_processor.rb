class DigitalTaxProcessor < BaseProcessor
  
  def initialize(transaction)
    super(transaction)
    @user_location = transaction.user_location
    @user_type = transaction.user_type
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

end

