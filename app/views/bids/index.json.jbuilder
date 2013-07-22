json.array!(@bids) do |bid|
  json.extract! bid, :what, :for, :count, :price, :rate, :reverse_rate, :user_id
  json.url bid_url(bid, format: :json)
end
