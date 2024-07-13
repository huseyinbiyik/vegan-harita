class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.approved.with_contributors
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @contributor = @product.contributors.new(user_id: current_user.id)

    respond_to do |format|
      if @product.save && @contributor.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    product_changes = Product.new(product_params)
    change_log = ChangeLog.new(product_params)
    change_log.changeable = @product
    change_log.user = current_user

    respond_to do |format|
      if product_changes.valid? && change_log.save!
        format.html { redirect_to products_path, notice: "Product was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    change_log = ChangeLog.find_by(changeable_id: @product.id)
    change_log.destroy!
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(
      :bar_code,
      :name_en,
      :name_tr,
      :ingredients_en,
      :ingredients_tr,
      :product_category_id,
      :brand_id,
      :image,
      :statement,
      shop_ids: [])
  end
end
