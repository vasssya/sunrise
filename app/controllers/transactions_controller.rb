class TransactionsController < ApplicationController
  def index
  	@transactions = Transaction.order('id DESC').page params[:page]
  end
end
