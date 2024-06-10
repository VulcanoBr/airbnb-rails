module Listings
  class FileUploadsController < ApplicationController
    def create
      @file = ActiveStorage::Blob.find_signed(params[:blob_signed_id])
      respond_to do |format|
        format.turbo_stream {}
      end
    end
  end
end