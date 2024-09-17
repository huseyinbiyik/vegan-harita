class Admin::ProductSubCategoriesController < Admin::ApplicationController
  before_action :set_product_sub_category, only: %i[ show edit update destroy ]

  def index
    @product_sub_categories = ProductSubCategory.all.includes(:product_category)
  end

  def show
  end

  def new
    @product_sub_category = ProductSubCategory.new
  end

  def edit
  end

  def create
    @product_sub_category = ProductSubCategory.new(product_sub_category_params)

    respond_to do |format|
      if @product_sub_category.save
        format.html { redirect_to admin_product_sub_category_url(@product_sub_category), notice: "Product sub category was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_sub_category.update(product_sub_category_params)
        format.html { redirect_to admin_product_sub_category_url(@product_sub_category), notice: "Product sub category was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_sub_category.destroy!

    respond_to do |format|
      format.html { redirect_to admin_product_sub_categories_url, notice: "Product sub category was successfully destroyed." }
    end
  end

  private
    def set_product_sub_category
      @product_sub_category = ProductSubCategory.find(params[:id])
    end

    def product_sub_category_params
      params.require(:product_sub_category).permit(:name_en, :name_tr, :product_category_id)
    end
end
