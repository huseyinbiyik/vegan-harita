class Admin::ProductCategoriesController < Admin::ApplicationController
  before_action :set_product_category, only: %i[ show edit update destroy ]

  def index
    @product_categories = ProductCategory.all
  end

  def show
  end

  def new
    @product_category = ProductCategory.new
  end

  def edit
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    respond_to do |format|
      if @product_category.save
        format.html { redirect_to admin_product_category_url(@product_category), notice: "Product category was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_category.update(product_category_params)
        format.html { redirect_to admin_product_category_url(@product_category), notice: "Product category was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_category.destroy!

    respond_to do |format|
      format.html { redirect_to admin_product_categories_url, notice: "Product category was successfully destroyed." }
    end
  end

  private
    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    def product_category_params
      params.require(:product_category).permit(:name_en, :name_tr)
    end
end
