''"
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
"''

EU_COUNTRIES = %i[france germany italy] # Some EU Countries

class TaxManager
  def self.calculate(product_type:, user_location: nil, user_type: nil, service_area: nil)
    case product_type
    when :good
      raise ArgumentError, 'user_location is required for goods' if user_location.nil?

      raise ArgumentError, 'user_type is required for goods' if user_type.nil?

      if user_location == :spain
        { tax: 'Spanish VAT', transaction_type: 'good' }
      elsif EU_COUNTRIES.include?(user_location)
        if user_type == :individual
          { tax: "#{user_location} VAT", transaction_type: 'good' }
        else
          { tax: 'No VAT', transaction_type: 'reverse charge' }
        end
      else
        { tax: 'No VAT', transaction_type: 'export' }
      end
    when :digital
      raise ArgumentError, 'user_location is required for goods' if user_location.nil?

      raise ArgumentError, 'user_type is required for goods' if user_type.nil?

      if user_location == :spain
        { tax: 'Spanish VAT', transaction_type: 'service, digital' }
      elsif EU_COUNTRIES.include?(user_location)
        if user_type == :individual
          { tax: "#{user_location} VAT", transaction_type: 'service, digital' }
        else
          { tax: 'No VAT', transaction_type: 'reverse charge' }
        end
      else
        { tax: 'No VAT', transaction_type: 'service, digital' }
      end
    when :onsite
      raise ArgumentError, 'service_area is required for onsite services' if service_area.nil?

      if service_area == :spain
        { tax: 'Spanish VAT', transaction_type: 'service, onsite' }
      else
        { tax: 'No VAT', transaction_type: 'service, onsite' }
      end
    else
      raise 'Unknown product type'
    end
  end
end






############################## Main Program ##############################
# puts TaxManager.calculate(:good, :spain, :individual)
# puts TaxManager.calculate(:digital, :germany, :individual)
# puts TaxManager.calculate(:onsite, :spain, :individual)
# puts TaxManager.calculate(:onsite, :usa, :individual)
# puts TaxManager.calculate(:invalid, :spain, :individual)


############################## Rspec Tests ##############################
describe TaxManager do
  describe '.calculate' do
    it 'calculates tax for goods in Spain' do
      expect(TaxManager.calculate(product_type: :good, user_location: :spain, user_type: :individual)).to eq({ tax: 'Spanish VAT', transaction_type: 'good' })
    end

    it 'calculates tax for digital services in EU for an individual' do
      expect(TaxManager.calculate(product_type: :digital, user_location: :france, user_type: :individual)).to eq({ tax: 'france VAT', transaction_type: 'service, digital' })
    end

    it 'calculates reverse charge for goods to an EU company' do
      expect(TaxManager.calculate(product_type: :good, user_location: :germany, user_type: :company)).to eq({ tax: 'No VAT', transaction_type: 'reverse charge' })
    end

    it 'marks goods sale as export outside EU' do
      expect(TaxManager.calculate(product_type: :good, user_location: :usa, user_type: :individual)).to eq({ tax: 'No VAT', transaction_type: 'export' })
    end

    it 'calculates tax for onsite services in Spain' do
      expect(TaxManager.calculate(product_type: :onsite, service_area: :spain)).to eq({ tax: 'Spanish VAT', transaction_type: 'service, onsite' })
    end
  end
end