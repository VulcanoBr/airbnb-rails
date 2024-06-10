module Listings
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_listing
    before_action :set_booking, only: ["payment", "success", "stripe_session"]
    def new
      @booking = @listing.bookings.new
    end
    def create 
      @booking = @listing.bookings.new(bookings_params)
      @booking.user = current_user
      if @booking.save
        redirect_to payment_listing_booking_path(@listing, @booking), notice: "Your stay was booked at #{@listing.title} for #{@booking.checkin_date.strftime("%m/%d/%Y")}"
      else
        render :new, status: :see_other
      end
    end

    def payment; end

    def success; end

    def stripe_session
      unit_amount = (@listing.day_price * 100) * @booking.amount_of_days
      checkout_session = Stripe::Checkout::Session.create({
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: "usd",
              unit_amount: unit_amount.to_i,
              product_data: {
                name: @listing.title
              },
            },
            quantity: 1,
          },
        ],
        payment_intent_data: {
          application_fee_amount: (unit_amount * 0.30).to_i,
          transfer_data: {destination: @listing.user.stripe_account_id},
        },
        metadata: {
          booking_id: @booking.id
        },
        customer_email: current_user.email,
        ui_mode: 'embedded',
        return_url: success_listing_booking_url(@listing, @booking),
      })

      render json: { clientSecret: checkout_session.client_secret }
    end

    private

    def set_listing
      @listing = Listing.friendly.find(params[:listing_id])
    end

    def set_booking
      @booking = @listing.bookings.find(params[:id])
    end

    def bookings_params
      params.require(:booking).permit(:checkin_date, :checkout_date)
    end
  end
end