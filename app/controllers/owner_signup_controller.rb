class OwnerSignupController < ApplicationController
  def show
  end

  def create
    current_user.create_stripe_account
  end
end