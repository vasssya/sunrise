class ProfileController < ApplicationController
  def show
  	@user = current_user
  	halt if @user.nil?
  end
end
