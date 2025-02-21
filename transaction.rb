class Transaction
  attr_reader :user_location, :user_type, :service_area

  def initialize(user_location, user_type, service_area)
    @user_location = user_location
    @user_type = user_type
    @service_area = service_area
  end
end