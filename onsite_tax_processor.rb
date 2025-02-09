class OnsiteTaxProcessor
  def initialize(service_area)
    @service_area = service_area
    validate!
  end

  def calculate
    if @service_area == :spain
      { tax_rate: TaxRates.rate(@service_area), transaction_type: 'service, onsite' }
    else
      { tax_rate: 0, transaction_type: 'service, onsite' }
    end
  end

  def validate!
    raise ArgumentError, 'service_area is required for onsite services' if @service_area.nil?
  end
end

