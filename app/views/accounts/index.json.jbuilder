json.array!(@accounts) do |account|
  json.extract! account, :currency, :amount, :reserved, :user_id
  json.url account_url(account, format: :json)
end
