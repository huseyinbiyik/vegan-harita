class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show search search_by_barcode ]
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @q = Product.approved.ransack(params[:q])
    @products = @q.result(distinct: true).joins(:shops).includes(:brand, :product_category, :product_sub_category, :shops, image_attachment: :blob).page(params[:page]).per(35)

    product_sub_categories
    @brands = Brand.all
    @shops = Shop.all
  end

  def search
    if params[:product_search].present?
      @products = Product.approved.filter_by_name(params[:product_search])
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

  def search_by_barcode
    @product = Product.find_by(bar_code: params[:bar_code])
    if @product
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("scan-result", partial: "products/product_info", locals: { product: @product })
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("scan-result", partial: "products/product_not_found")
        end
      end
    end
  end

  def show
    @contributors = @product.contributors
    @reviews = @product.reviews.approved if @product.reviews.present?
    add_breadcrumb(Product.model_name.human(count: :many), products_path)
    add_breadcrumb(@product.product_category.name, products_path(q: { product_category_id_eq_any: [ @product.product_category_id ] }))
    add_breadcrumb(@product.product_sub_category.name, products_path(q: { product_sub_category_id_eq_any: [ @product.product_sub_category_id ] }))
    add_breadcrumb(@product.name, product_path(@product.slug))
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.approved = true if current_user.admin?
    @contributor = @product.contributors.new(user_id: current_user.id)

    respond_to do |format|
      if @product.save && @contributor.save
        format.html { redirect_to products_path, notice: t("success.created", model: Product.model_name.human) }
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
        format.html { redirect_to products_path, notice: t("success.updated", model: Product.model_name.human) }
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
      format.html { redirect_to products_url, notice: t("success.destroyed", model: Product.model_name.human) }
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

  def product_sub_categories
    if params[:q] && params[:q][:product_category_id_eq_any].present?
      category_ids = params[:q][:product_category_id_eq_any].reject(&:blank?)
      if category_ids.any?
        @product_sub_categories = ProductCategory.includes(product_sub_categories: :string_translations).where(id: category_ids).map(&:product_sub_categories).flatten
      else
        @product_sub_categories = ProductSubCategory.includes(:string_translations).all
      end
    else
      @product_sub_categories = ProductSubCategory.includes(:string_translations).all
    end
  end
end
