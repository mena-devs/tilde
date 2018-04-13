class PartnersController < ApplicationController
  before_action :set_partner, only: [:edit, :update, :destroy]

  # devise authentication required to access partners
  before_action :authenticate_user!, :except => [:index]
  before_action :authenticate_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /partners
  def index
    @partners = Partner.all
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit
  end

  # POST /partners
  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      redirect_to @partner, notice: 'Partner was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /partners/1
  def update
    if @partner.update(partner_params)
      redirect_to @partner, notice: 'Partner was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /partners/1
  def destroy
    @partner.destroy
    redirect_to partners_url, notice: 'Partner was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def partner_params
      params.require(:partner).permit(:name, :description, :external_link, :email, :active, :picture)
    end
end
