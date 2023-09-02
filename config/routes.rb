# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :places do
    post "place-edits", to: "place_edits#create", as: :place_edits
    post "place-edits/:id/approve", to: "place_edits#approve", as: :approve_place_edit
    delete "place-edits/:id", to: "place_edits#destroy", as: :destroy_place_edit
    resources :menus
    collection do
      post :search
    end
  end

  scope 'admin-panel' do
    get "user-approvals", to: "admins#user_approvals", as: :user_approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    get "place-approvals", to: "admins#approve_place_edit", as: :place_approvals
  end


  root 'places#index'
end
