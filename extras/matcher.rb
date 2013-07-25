class Matcher
	require 'colored'
  def self.run
  	status = { new_found: 0, matched: 0}
  	new_bids = Bid.where(state: 'new').order('created_at ASC')
  	status[:new_found] = new_bids.count
		new_bids.each do |bid|
			begin
				match_bids = Bid.where(state: 'started',
					buy_currency: bid.sell_currency, sell_currency: bid.buy_currency).where(
					"reverse_rate <= #{bid.rate}").order('reverse_rate ASC')
				match_bids.each do |match_bid|
					begin
						puts "MATCH #{bid.id} - #{match_bid.id}"
						status[:matched] += 1
						if bid.amount <= match_bid.max_price and match_bid.amount <= bid.max_price
							puts 'amount == max_price'.bold.blue
							ActiveRecord::Base.transaction do
							  bid.done!
							  match_bid.done!

							  Transaction.create! from: bid.account_sell,
							  										to: match_bid.account_buy,
							  										amount: match_bid.amount,
							  										bids: [bid.id, match_bid.id]

							  Transaction.create! from: match_bid.account_sell,
							  										to: bid.account_buy,
							  										amount: bid.amount,
							  										bids: [bid.id, match_bid.id]
							end
						elsif bid.amount > match_bid.max_price and match_bid.amount <= bid.max_price
							ActiveRecord::Base.transaction do
								match_bid.done!
								bid.partially_done! match_bid.amount, match_bid.max_price

							  Transaction.create! from: bid.account_sell,
							  										to: match_bid.account_buy,
							  										amount: match_bid.amount,
							  										bids: [bid.id, match_bid.id]

							  Transaction.create! from: match_bid.account_sell,
							  										to: bid.account_buy,
							  										amount: match_bid.max_price,
							  										bids: [bid.id, match_bid.id]
							end
						elsif match_bid.amount > bid.max_price and bid.amount <= match_bid.max_price
							ActiveRecord::Base.transaction do
								bid.done!
								match_bid.partially_done! bid.amount, bid.max_price

							  Transaction.create! from: bid.account_sell,
							  										to: match_bid.account_buy,
							  										amount: bid.max_price,
							  										bids: [bid.id, match_bid.id]

							  Transaction.create! from: match_bid.account_sell,
							  										to: bid.account_buy,
							  										amount: bid.amount,
							  										bids: [bid.id, match_bid.id]
							end
						end
						puts "MATCH SUCCSESS"
					rescue ActiveRecord::StatementInvalid => ex
						if match_bid.max_price > match_bid.account_sell.amount
							match_bid.update_attributes state: :bad
						elsif bid.max_price > bid.account_sell.amount
							raise InsufficientFunds, "Bid #{bid.id}, user #{bid.user.id}"
						else
							raise ex
						end
					end
				end
				bid.update_attribute(:state, 'started') if bid.state == 'new'
			rescue InsufficientFunds => ex
				puts "Catch InsufficientFunds exeption: #{ex.message}".bold.red
				bid.update_attributes state: :bad
			end
		end
		return status
	end

end
