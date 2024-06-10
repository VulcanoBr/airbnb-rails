module Stripe
  class AccountSessionsController < ApplicationController
    def create
      account_session = Stripe::AccountSession.create({
        account: current_user.stripe_account_id,
        components: {
          account_onboarding: {
            enabled: true,
            features: {external_account_collection: true},
          },
        },
      })
      render json: {
        client_secret: account_session[:client_secret]
      }
    end
  end
end