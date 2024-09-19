class Admin::ShopsController < Admin::ApplicationController
  before_action :set_shop, only: %i[ show edit update destroy ]

  # GET /admin/shops or /admin/shops.json
  def index
    @shops = Shop.all
  end

  # GET /admin/shops/1 or /admin/shops/1.json
  def show
  end

  # GET /admin/shops/new
  def new
    @shop = Shop.new
  end

  # GET /admin/shops/1/edit
  def edit
  end

  # POST /admin/shops or /admin/shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to admin_shop_url(@shop), notice: "Shop was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shops/1 or /admin/shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to admin_shop_url(@shop), notice: "Shop was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shops/1 or /admin/shops/1.json
  def destroy
    @shop.destroy!

    respond_to do |format|
      format.html { redirect_to admin_shops_url, notice: "Shop was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name)
    end
end
