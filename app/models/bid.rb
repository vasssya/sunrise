class Bid < ActiveRecord::Base
  belongs_to :user
  validates :buy_currency, :sell_currency, :amount, :max_price, presence: true
  validate :user_have_sufficient_funds
  validate :currencies_in_available_currencies
  validate :currencies_not_same

  before_create :calculate

  def account_buy
    user.accounts.where(currency: buy_currency).first
  end

  def account_sell
    user.accounts.where(currency: sell_currency).first
  end

  def done! closing_price = max_price
    self.state = 'done'
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts SET amount = amount - #{closing_price} WHERE id = #{account_sell.id}")
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts SET amount = amount + #{amount} WHERE id = #{account_buy.id}")
    self.info += "Bid closed with price: #{closing_price}" # TODO transactions log
    save!
  end

  def partially_done! foreign_amount, foreign_price
    self.amount    -= foreign_price
    self.max_price -= foreign_amount
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts SET amount = amount - #{foreign_amount} WHERE id = #{account_sell.id}")
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts SET amount = amount + #{foreign_price} WHERE id = #{account_buy.id}")
    save!
  end

  def user_have_sufficient_funds
    # TODO funds reservation and validation through all bids
    account = user.accounts.find_by(currency: sell_currency)
    if account.nil? or account.amount < max_price
      errors.add :max_price, 'not enough funds'
    end
  end

  def currencies_in_available_currencies
    errors.add(:buy_currency, 'unknown currency') unless Rails.configuration.currencies.include? buy_currency
    errors.add(:sell_currency, 'unknown currency') unless Rails.configuration.currencies.include? sell_currency
  end

  def currencies_not_same
    if sell_currency == buy_currency
      errors.add :buy_currency, 'currency same as sell'
      errors.add :sell_currency, 'currency same as buy'
    end
  end

  def calculate
    self.rate = max_price/amount
    self.reverse_rate = amount/max_price
  end

end
