require_relative 'transaction'
require_relative 'base_processor'
class TaxProcessor
  def self.calculate(product_type:, user_location: nil, user_type: nil, service_area: nil)
    
    transaction = Transaction.new(user_location, user_type, service_area)

    processor = case product_type
                when :good
                  PhysicalTaxProcessor.new(transaction)
                when :digital
                  DigitalTaxProcessor.new(transaction)
                when :onsite
                  OnsiteTaxProcessor.new(transaction)
                else
                  raise 'Unknown product type'
                end        
    processor.calculate
  end
end
