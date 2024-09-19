class ProductSubCategoriesController < ApplicationController
  def index
    product_category = ProductCategory.find(params[:category_id])
    @product_sub_categories = product_category.product_sub_categories
  end
end
