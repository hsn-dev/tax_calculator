class TaxProcessor
  def self.calculate(product_type:, user_location: nil, user_type: nil, service_area: nil)
    processor = case product_type
                when :good
                  PhysicalTaxProcessor.new(user_location, user_type)
                when :digital
                  DigitalTaxProcessor.new(user_location, user_type)
                when :onsite
                  OnsiteTaxProcessor.new(service_area)
                else
                  raise 'Unknown product type'
                end
    processor.calculate
  end
end
