require 'machinist/active_record'

User.blueprint do
  pwd = Faker::Lorem.characters(9)
  password { pwd }
  password_confirmation { pwd }
  email { "test#{sn}" + Faker::Internet.email }
end

Bid.blueprint do
	buy_currency { :btc }
	sell_currency  { :usd }
	amount { 10 }
	max_price { 300 }
	user { User.make! }
end
