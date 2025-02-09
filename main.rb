"""
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
"""

class TaxManager
  def self.calculate(product_type, user_location, user_type)
    if product_type == :good
      if user_location == :spain
        { tax: 'Spanish VAT', transaction_type: 'good' }
      elsif [:france, :germany, :italy].include?(user_location)
        if user_type == :individual
          { tax: "#{user_location} VAT", transaction_type: 'good' }
        else
          { tax: 'No VAT', transaction_type: 'reverse charge' }
        end
      else
        { tax: 'No VAT', transaction_type: 'export' }
      end
    elsif product_type == :digital
      if user_location == :spain
        { tax: 'Spanish VAT', transaction_type: 'service, digital' }
      elsif [:france, :germany, :italy].include?(user_location)
        if user_type == :individual
          { tax: "#{user_location} VAT", transaction_type: 'service, digital' }
        else
          { tax: 'No VAT', transaction_type: 'reverse charge' }
        end
      else
        { tax: 'No VAT', transaction_type: 'service, digital' }
      end
    end
  end
end






############################## Main Program ##############################
puts TaxManager.calculate(:good, :spain, :individual)
puts TaxManager.calculate(:digital, :germany, :individual)