# frozen_string_literal: true

Rails.application.routes.draw do
  get "service-worker" => "pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "pwa#manifest", as: :pwa_manifest

  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end

  root "places#index"
  get "contact", to: "home#contact"
  get "account_links", to: "static#account_links"
  get "coming_soon", to: "static#coming_soon"
  post "send_mail", to: "home#send_mail"

  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }

  resources :places, param: :slug do
    resources :menus do
      resource :likes, module: :menus
    end
    resources :claims, only: %i[new create]
    collection do
      post :search
    end
  end
  resources :reviews, except: %i[index show]

  resources :products, param: :slug do
    collection do
      post :search
      post :search_by_barcode
      get :barcode_scanner
    end
  end
  resources :product_sub_categories, only: :index

  resource :change_logs, only: %i[new create]

  namespace "admin" do
    root "dashboard#index"
    resource :dashboard, only: %i[index]
    get "approvals", to: "admins#approvals", as: :approvals
    post "approve-claim/:id", to: "admins#approve_claim", as: :approve_claim
    delete "reject-claim/:id", to: "admins#reject_claim", as: :reject_claim
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    post "approve-place/:id", to: "admins#approve_place", as: :approve_place
    delete "reject-place/:id", to: "admins#reject_place", as: :reject_place
    post "approve-place-edit/:id", to: "admins#approve_place_edit", as: :approve_place_edit
    delete "reject-place-edit/:id", to: "admins#reject_place_edit", as: :reject_place_edit
    post "approve-product/:id", to: "admins#approve_product", as: :approve_product
    delete "reject-product/:id", to: "admins#reject_product", as: :reject_product
    post "approve-product-edit/:id", to: "admins#approve_product_edit", as: :approve_product_edit
    delete "reject-product-edit/:id", to: "admins#reject_product_edit", as: :reject_product_edit
    post "approve-menu/:id", to: "admins#approve_menu", as: :approve_menu
    delete "reject-menu/:id", to: "admins#reject_menu", as: :reject_menu
    post "approve-menu-edit/:id", to: "admins#approve_menu_edit", as: :approve_menu_edit
    delete "reject-menu-edit/:id", to: "admins#reject_menu_edit", as: :reject_menu_edit
    post "approve-review/:id", to: "admins#approve_review", as: :approve_review
    delete "reject-review/:id", to: "admins#reject_review", as: :reject_review
    get "edit_note_form/:id", to: "admins#edit_note_form", as: :edit_note_form
    patch "update_note/:id", to: "admins#update_note", as: :update_note
    resources :brands
    resources :shops
    resources :product_categories
    resources :product_sub_categories
  end

  namespace :place_owner do
    resources :summary, param: :slug, only: %i[show]
    resources :feedbacks, param: :slug, only: %i[show]
    resources :qr_code, param: :slug, only: %i[show]
    get "download_qr/:slug", to: "qr_code#download", as: :download_qr
  end

  scope "legals" do
    get "privacy-policy", to: "legals#privacy_policy"
    get "terms-of-use", to: "legals#terms_of_use"
    get "cookie-policy", to: "legals#cookie_policy"
    get "user-agreement", to: "legals#user_agreement"
  end

  direct :rails_public_blob do |blob|
    if Rails.application.credentials.dig(:aws, :cloudfront_attachment_url) && blob&.key
      File.join(Rails.application.credentials.dig(:aws, :cloudfront_attachment_url), blob.key)
    else
      route =
        if blob.is_a?(ActiveStorage::Variant) || blob.is_a?(ActiveStorage::VariantWithRecord)
          :rails_representation
        else
          :rails_blob
        end
      route_for(route, blob)
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
