'' "
Assignment:
-----------

A multinational Munchitos S.A. is going to launch an online platform to sell a myriad of products and services.
- Food products
    - individual consumers
    - companies
- Digital subscription services
    - professionals in the foodservice industry
    - include access to exclusive content and resources
- In-person training courses
    - chefs and restaurants, organized in various cities

Build an automated system for
    - calculating taxes on sales made on platform
    - comply with the tax regulations of each country

We will assume that the seller, Munchitos S.A., is a company operating from Spain, a member country of the European Union (EU).

Requirements:
- Sale of physical products
    - Transaction type = good
    - Buyer
        - Spain Resident
            - Spanish VAT will be applied, regardless of whether it is an individual consumer or a company.
        - Outside Spain, but in an EU country
            - Individual consumer
                - the local VAT of the buyers country will be applied
            - Buyer is a company, no VAT will be applied
                - transaction_type = reverse_charge
        - Buyer is in a country outside the EU
            - No tax will be applied
            - transaction_type = export
- Sale of digital services
    - transaction_type = service and digital
    - Buyer
        - Spain Resident
            - Spanish VAT will be applied, regardless of whether it is an individual consumer or a company.
        - Outside Spain, but in an EU country
            - Individual consumer
                - the local VAT of the buyers country will be applied
            - Buyer is a company, no VAT will be applied
                - transaction_type = reverse_charge
        - Buyer is in a country outside the EU
            - No tax will be applied
- Sale of onsite services
    - transaction_type = service and onsite
    - Service in Spain?
        - Spanish VAT will be applied
        - Regardless of buyer location [ spain, inside EU, outside EU ] and buyer type (individual or company)
        - In this case, the place where the service is provided (where the course takes place) defines the applicable tax.
" ''

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
                  raise "Unknown product type"
                end
    processor.calculate
  end
end

class PhysicalTaxProcessor
  def initialize(user_location, user_type)
    @user_location = user_location
    @user_type = user_type
    validate!
  end

  def calculate
    if @user_location == :spain
      { tax_rate: TaxRates.rate(@user_location), transaction_type: 'physical' }
    elsif TaxRates.eu_country?(@user_location)
      if @user_type == :individual
        { tax_rate: TaxRates.rate(@user_location), transaction_type: 'physical' }
      else
        { tax_rate: 0, transaction_type: 'reverse charge' }
      end
    else
      { tax_rate: 0, transaction_type: 'export' }
    end
  end

  def validate!
    raise ArgumentError, 'user_location is required' if @user_location.nil?
    raise ArgumentError, 'user_type is required' if @user_type.nil?
  end
end

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

############################## Main Program ##############################
# puts TaxProcessor.calculate(:good, :spain, :individual)
# puts TaxProcessor.calculate(:digital, :germany, :individual)
# puts TaxProcessor.calculate(:onsite, :spain, :individual)
# puts TaxProcessor.calculate(:onsite, :usa, :individual)
# puts TaxProcessor.calculate(:invalid, :spain, :individual)

############################## Rspec Tests ##############################
describe TaxProcessor do
  describe '.calculate' do
    it 'calculates tax for goods in Spain' do
      expect(TaxProcessor.calculate(product_type: :good, user_location: :spain, user_type: :individual)).to eq({ tax_rate: 0.20, transaction_type: 'physical' })
    end

    it 'calculates tax for digital services in EU for an individual' do
      expect(TaxProcessor.calculate(product_type: :digital, user_location: :france, user_type: :individual)).to eq({ tax_rate: 0.18, transaction_type: 'service, digital' })
    end

    it 'calculates reverse charge for goods to an EU company' do
      expect(TaxProcessor.calculate(product_type: :good, user_location: :germany, user_type: :company)).to eq({ tax_rate: 0, transaction_type: 'reverse charge' })
    end

    it 'marks goods sale as export outside EU' do
      expect(TaxProcessor.calculate(product_type: :good, user_location: :usa, user_type: :individual)).to eq({ tax_rate: 0, transaction_type: 'export' })
    end

    it 'calculates tax for onsite services in Spain' do
      expect(TaxProcessor.calculate(product_type: :onsite, service_area: :spain)).to eq({ tax_rate: 0.20, transaction_type: 'service, onsite' })
    end
  end
end