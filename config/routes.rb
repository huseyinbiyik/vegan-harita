# frozen_string_literal: true

Rails.application.routes.draw do
  root "places#index"
  get "contact", to: "home#contact"
  post "send_mail", to: "home#send_mail"

  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  resources :places do
    resources :reviews, except: %i[index show]
    resources :menus do
      resource :likes, module: :menus
    end
    collection do
      post :search
    end
  end

  scope "admin-panel" do
    get "approvals", to: "admins#approvals", as: :approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    post "approve-place/:id", to: "admins#approve_place", as: :approve_place
    delete "reject-place/:id", to: "admins#reject_place", as: :reject_place
    post "approve-place-edit/:id", to: "admins#approve_place_edit", as: :approve_place_edit
    delete "reject-place-edit/:id", to: "admins#reject_place_edit", as: :reject_place_edit
    post "approve-menu/:id", to: "admins#approve_menu", as: :approve_menu
    delete "reject-menu/:id", to: "admins#reject_menu", as: :reject_menu
    post "approve-menu-edit/:id", to: "admins#approve_menu_edit", as: :approve_menu_edit
    delete "reject-menu-edit/:id", to: "admins#reject_menu_edit", as: :reject_menu_edit
    post "approve-review/:id", to: "admins#approve_review", as: :approve_review
    delete "reject-review/:id", to: "admins#reject_review", as: :reject_review
    get "edit_note_form/:id", to: "admins#edit_note_form", as: :edit_note_form
    patch "update_note/:id", to: "admins#update_note", as: :update_note
  end

  scope "legals" do
    get "privacy-policy", to: "legals#privacy_policy"
    get "terms-of-use", to: "legals#terms_of_use"
    get "cookie-policy", to: "legals#cookie_policy"
    get "user-agreement", to: "legals#user_agreement"
  end

  direct :cdn_proxy do |model, options|
    expires_in = options.delete(:expires_in) { ActiveStorage.urls_expire_in }

    if Rails.env.production?
      if model.respond_to?(:signed_id)
        route_for(
          :rails_service_blob_proxy,
          model.signed_id(expires_in: expires_in),
          model.filename,
          options.merge(host: Rails.application.credentials.dig(:aws, :cloudfront_attachment_url))
        )
      else
        signed_blob_id = model.blob.signed_id(expires_in: expires_in)
        variation_key  = model.variation.key
        filename       = model.blob.filename

        route_for(
          :rails_blob_representation_proxy,
          signed_blob_id,
          variation_key,
          filename,
          options.merge(host: Rails.application.credentials.dig(:aws, :cloudfront_attachment_url))
        )
      end
    else
      if model.respond_to?(:signed_id)
        url_for(model)
      else
        rails_representation_url(model)
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
