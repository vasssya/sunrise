class Account < ActiveRecord::Base
  belongs_to :user
  has_many :ins, class_name: 'Transaction', foreign_key: :to_id
  has_many :outs, class_name: 'Transaction', foreign_key: :from_id
end
