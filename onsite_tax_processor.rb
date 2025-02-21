class OnsiteTaxProcessor < BaseProcessor

  def initialize(transaction)
    super(transaction)
    @service_area = transaction.service_area
  end

  def calculate
      { tax_rate: TaxRates.rate(@service_area), transaction_type: 'service, onsite' }
  end
end

