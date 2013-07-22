user  = User.create! email: 'user@example.com', password: '123123123'
admin = User.create! email: 'admin@example.com', password: '123123123'

user.btc.update_attributes amount: 100
user.usd.update_attributes amount: 1000
admin.btc.update_attributes amount: 100
admin.usd.update_attributes amount: 1000

Bid.create! user: user, buy_currency: 'usd', sell_currency: 'btc', amount: 300, max_price: 10
Bid.create! user: admin, buy_currency: 'btc', sell_currency: 'usd', amount: 10, max_price: 300
Bid.create! user: admin, buy_currency: 'btc', sell_currency: 'usd', amount: 10, max_price: 200
Bid.create! user: admin, buy_currency: 'btc', sell_currency: 'usd', amount: 10, max_price: 400
