class WeatherController < ApplicationController
  # GET /weather/:zip
  def show
    @address = Address.new(zip: params[:zip], country: "US")

    if @address.valid?
      geocodes = Geocode.search(postalcode: @address.zip, country: @address.country)
      if geocodes.any?
        @geocode = geocodes.first
        @forecast = OpenMeteo::V1.forecast(latitude: @geocode['lat'], longitude: @geocode['lon'])
      else
        redirect_to root_path, notice: "Unable to find geocodes for postal code #{@address.zip}"
      end
    else
      redirect_to root_path, notice: @address.errors.full_messages.join("\n")
    end
  end

  # GET /
  def index
    @address = Address.new
  end

  # POST /weather
  def create
    @address = Address.new(address_params)

    if @address.valid?
      @geocodes = Geocode.search(
        street: @address.street,
        city: @address.city,
        state: @address.state,
        postalcode: @address.zip,
        country: @address.country
      )
    end

    render :index
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip, :country).tap do |defaults|
      defaults[:country] = "US"
    end
  end
end
