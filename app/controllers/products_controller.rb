class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @q = Product.approved.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:brand, :product_category, :shops, :contributors)

    if params[:q] && params[:q][:product_category_id_eq].present?
      @product_sub_categories = ProductCategory.find(params[:q][:product_category_id_eq]).product_sub_categories
    else
      @product_sub_categories = ProductSubCategory.all
    end
  end

  def search
    if params[:name_search].present?
      @products = Product.approved.filter_by_name(params[:name_search])
    else
      []
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search-results", partial: "products/search_results",
                                                 locals: { products: @products })
      end
    end
  end

  def show
    @contributors = @product.contributors
  end

  def new
    @product = Product.new
  end


  def create
    @product = Product.new(product_params)
    @contributor = @product.contributors.new(user_id: current_user.id)

    respond_to do |format|
      if @product.save && @contributor.save
        format.html { redirect_to products_path, notice: "Product was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

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

  def destroy
    change_log = ChangeLog.find_by(changeable_id: @product.id)
    change_log.destroy!
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
    end
  end

  private

  def set_product
    @product = Product.find_by(slug: params[:slug])
  end

  def product_params
    params.require(:product).permit(
      :bar_code,
      :name,
      :ingredients_en,
      :ingredients_tr,
      :product_category_id,
      :product_sub_category_id,
      :brand_id,
      :image,
      :statement,
      shop_ids: [])
  end
end
