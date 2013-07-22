class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.string  :buy_currency
      t.string  :sell_currency
      t.decimal :amount
      t.decimal :max_price
      t.decimal :rate
      t.decimal :reverse_rate
      t.string  :state, null: false, default: 'new'
      t.text    :info, null: false, default: ''
      t.references :user, index: true

      t.timestamps
    end
  end
end
