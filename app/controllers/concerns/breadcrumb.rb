module Breadcrumb
  extend ActiveSupport::Concern

  included do
    helper_method :breadcrumbs
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  private

  def add_breadcrumb(name, path = nil)
    breadcrumbs << BreadcrumbItem.new(name, path)
  end
end
