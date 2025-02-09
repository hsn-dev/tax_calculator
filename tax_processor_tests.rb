require_relative 'tax_processor'
require_relative 'onsite_tax_processor'
require_relative 'physical_tax_processor'
require_relative 'digital_tax_processor'
require_relative 'tax_rates'

describe TaxProcessor do
  describe '.calculate' do
    it 'calculates tax for goods in Spain' do
      expect(described_class.calculate(product_type: :good, user_location: :spain, user_type: :individual)).to eq({ tax_rate: 0.20, transaction_type: 'physical' })
    end

    it 'calculates tax for digital services in EU for an individual' do
      expect(described_class.calculate(product_type: :digital, user_location: :france, user_type: :individual)).to eq({ tax_rate: 0.18, transaction_type: 'service, digital' })
    end

    it 'calculates reverse charge for goods to an EU company' do
      expect(described_class.calculate(product_type: :good, user_location: :germany, user_type: :company)).to eq({ tax_rate: 0, transaction_type: 'reverse charge' })
    end

    it 'marks goods sale as export outside EU' do
      expect(described_class.calculate(product_type: :good, user_location: :usa, user_type: :individual)).to eq({ tax_rate: 0, transaction_type: 'export' })
    end

    it 'calculates tax for onsite services in Spain' do
      expect(described_class.calculate(product_type: :onsite, service_area: :spain)).to eq({ tax_rate: 0.20, transaction_type: 'service, onsite' })
    end
  end
end