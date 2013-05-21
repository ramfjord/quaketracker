class QuakesController < ApplicationController
  # GET /nearme
  # GET /quakes.json
  def nearme
    if params[:address]
      @address = params[:address]
      @latitude, @longitude = Geocoder.coordinates @address
      @update_search = true
    elsif params[:latitude] && params[:longitude]
      @latitude, @longitude = params[:latitude].to_f, params[:longitude].to_f
      @update_search = true unless params[:from_drag]
    else
      @latitude, @longitude = 45.37206, -122.642616
    end

    d = 3
    @quakes = Quake.within_box(@latitude - d, @longitude - 3*d,
                               @latitude + d, @longitude + 3*d).over(1.0)
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @quakes }
    end
  end

  # GET /quakes
  # GET /quakes.json
  def index
    parse_search_params
    @quakes = Quake.all if @quakes == Quake

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quakes }
    end
  end

  # GET /quakes/1
  # GET /quakes/1.json
  def show
    @quake = Quake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js { render 'move_to' } # index.js.erb
      format.json { render json: @quake }
    end
  end

  private
  
  def parse_search_params
    @quakes ||= Quake
    if params[:over]
      @magnitude = params[:over].to_f
      @quakes = @quakes.over(@magnitude)
    end

    if params[:since]
      @quakes = @quakes.since(params[:since].to_i)
    end

    if params[:on]
      @quakes = @quakes.on(params[:on].to_i)
    end

    if params[:near]
      lat, lon = params[:near].split(",").map(&:to_f)
      @quakes = @quakes.near5(lat, lon, @quakes)
    end

    @quakes
  end
end
