class GetawaySearchesController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:edit, :update, :vote, :destroy]

  before_action :set_getaway_search, only: [:show, :edit, :update, :destroy, :vote]

  # GET /getaway_searches
  # GET /getaway_searches.json
  def index
    @getaway_searches = GetawaySearch.all.order("created_at desc")
    @getaway_search = GetawaySearch.new(leave_on: "a_friday", return_on: "following_sunday")
  end

  # GET /getaway_searches/1
  # GET /getaway_searches/1.json
  def show
  end

  # GET /getaway_searches/new
  def new
    @getaway_search = GetawaySearch.new(leave_on: "a_friday", return_on: "following_sunday")
    # @getaway_searches = GetawaySearch.all
  end

  # GET /getaway_searches/1/edit
  def edit
  end

  # POST /getaway_searches
  # POST /getaway_searches.json
  def create
    @getaway_search = GetawaySearch.new(getaway_search_params)
    @getaway_search.user = current_user

    respond_to do |format|
      if @getaway_search.save
        format.html { redirect_to @getaway_search, notice: 'Getaway search was successfully created.' }
        format.json { render :show, status: :created, location: @getaway_search }
      else
        format.html { render :new }
        format.json { render json: @getaway_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /getaway_searches/1
  # PATCH/PUT /getaway_searches/1.json
  def update
    respond_to do |format|
      if @getaway_search.update(getaway_search_params)
        format.html { redirect_to @getaway_search, notice: 'Getaway search was successfully updated.' }
        format.json { render :show, status: :ok, location: @getaway_search }
      else
        format.html { render :edit }
        format.json { render json: @getaway_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getaway_searches/1
  # DELETE /getaway_searches/1.json
  def destroy
    @getaway_search.destroy
    respond_to do |format|
      format.html { redirect_to getaway_searches_url, notice: 'Getaway search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote

    direction = params[:direction]

    # Make sure we've specified a direction
    raise "No direction parameter specified to #vote action." unless direction

    # Make sure the direction is valid
    unless ["like", "bad"].member? direction
      raise "Direction '#{direction}' is not a valid direction for vote method."
    end

    @getaway_search.vote_by voter: current_user, vote: direction

    redirect_to action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_getaway_search
      @getaway_search = GetawaySearch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def getaway_search_params
      params.require(:getaway_search).permit(:fly_from, :price_limit, :user_id, :ip_address, :leave_on, :return_on)
    end
end
