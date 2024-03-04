class Users::SessionsController < Devise::SessionsController
  before_action :set_meta_tags, only: [ :new ]

  private

  def set_meta_tags
    @page_title = t("titles.sessions.new")
  end
end
