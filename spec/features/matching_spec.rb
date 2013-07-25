require 'spec_helper'

describe "Matching" do

	let(:user1){ User.make!}
	let(:user2){ User.make!}

	def add_user_money
		user1.usd.update_attributes amount: 10000
		user1.btc.update_attributes amount: 100
		user2.usd.update_attributes amount: 10000
		user2.btc.update_attributes amount: 100
	end

	it 'equal bids' do
		add_user_money
		b1 = user1.bids.create! buy_currency: 'btc', amount: 10, sell_currency: 'usd', max_price: 1000
		b2 = user2.bids.create! buy_currency: 'usd', amount: 1000, sell_currency: 'btc', max_price: 10
		Matcher.run
		b1.reload.state.should == 'done'
		b2.reload.state.should == 'done'
		user1.usd.amount.should == 9000
		user1.btc.amount.should == 110
		user2.usd.amount.should == 11000
		user2.btc.amount.should == 90
	end

	it 'not equal bids' do
		add_user_money
		b1 = user1.bids.create! buy_currency: 'btc', amount: 11, sell_currency: 'usd', max_price: 2200
		b2 = user2.bids.create! buy_currency: 'usd', amount: 1000, sell_currency: 'btc', max_price: 10
		Matcher.run
		b1.reload.state.should == 'started'
		b1.amount.should == 1
		b1.max_price == 1200
		b2.reload.state.should == 'done'
		user1.usd.amount.should == 9000
		user1.btc.amount.should == 110
		user2.usd.amount.should == 11000
		user2.btc.amount.should == 90
	end

	it 'not equal bids 2' do
		add_user_money
		b2 = user2.bids.create! buy_currency: 'usd', amount: 1000, sell_currency: 'btc', max_price: 10
		b1 = user1.bids.create! buy_currency: 'btc', amount: 11, sell_currency: 'usd', max_price: 2200
		Matcher.run
		b1.reload.state.should == 'started'
		b1.reload.amount.to_i.should == 1
		b1.max_price == 1200
		b2.reload.state.should == 'done'
		user1.usd.amount.should == 9000
		user1.btc.amount.should == 110
		user2.usd.amount.should == 11000
		user2.btc.amount.should == 90
	end

	it 'creates transactions' do
		add_user_money
		b2 = user2.bids.create! buy_currency: 'usd', amount: 1000, sell_currency: 'btc', max_price: 10
		b1 = user1.bids.create! buy_currency: 'btc', amount: 11, sell_currency: 'usd', max_price: 2200
		Matcher.run
		Transaction.count.should == 2
		user2.usd.in_transactions.count.should == 1
		user2.btc.out_transactions.count.should == 1
		user1.btc.in_transactions.count.should == 1
		user1.usd.out_transactions.count.should == 1
	end

end
