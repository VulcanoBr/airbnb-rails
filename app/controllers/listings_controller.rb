class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy photos ]
  before_action :redirect_to_signup, only: ["new", "create"]
  before_action :authorize_owner, only: ["edit", "update", "destroy"]
  # GET /listings or /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = current_user.listings.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    @listing = current_user.listings.new(listing_params)

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy!

    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def photos
  end

  private

    def authorize_owner
      redirect_to(root_path, alert: "You are not allowed to view this page") if current_user != @listing.user
    end

    def redirect_to_signup
      return redirect_to(new_user_session_path, alert: "You must sign in before you can create a listing") if !current_user
      redirect_to owner_signup_path if current_user.stripe_status == "pending"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :address, :description, 
      :bathrooms, :bedrooms, :people_limit, :day_price, :weekly_price, :monthly_price,
      images: [])
    end
end
