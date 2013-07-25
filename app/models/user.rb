class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bids
  has_many :accounts


  after_create :create_user_accounts

  def create_user_accounts
  	Rails.configuration.currencies.each do |c|
  		accounts.create currency: c
  	end
  end

  Rails.configuration.currencies.each do |c|
    define_method(c) { accounts.find_by(currency: c) }
  end

end
