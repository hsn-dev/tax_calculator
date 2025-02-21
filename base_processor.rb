class BaseProcessor
  attr_reader :transaction

  def initialize(transaction)
    @transaction = transaction
  end

  def calculate
    raise "Remeber to define calculate method"
  end

  def validate!
    raise ArgumentError, 'transaction is required' if transaction.nil?
  end
end