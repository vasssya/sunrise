class Account < ActiveRecord::Base
  belongs_to :user
  has_many :in_transactions, class_name: 'Transaction', foreign_key: :to_id
  has_many :out_transactions, class_name: 'Transaction', foreign_key: :from_id

  before_create :add_demo_money_in_production

  def add_demo_money_in_production
    if Rails.env.production?
    	case currency
    	when 'btc'
    		self.amount = 10
    	when 'usd'
    		self.amount = 1000
    	when 'eur'
    		self.amount = 500
    	end
    end
  end

end
