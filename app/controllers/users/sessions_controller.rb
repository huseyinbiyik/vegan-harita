class Users::SessionsController < Devise::SessionsController
  before_action :set_page_title, only: [ :new ]

  private

  def set_page_title
    @page_title = t("titles.sessions.new")
  end
end
