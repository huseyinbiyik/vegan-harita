class ProductSubCategoriesController < ApplicationController
  def index
    product_category = ProductCategory.find(params[:category_id])
    @product_sub_categories = product_category.product_sub_categories.includes(:string_translations)
    @product_sub_category_id = params[:product_sub_category_id]
  end
end
