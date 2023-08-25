# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :places do
    resources :menus
    collection do
      post :search
    end
  end

  scope 'admin-panel' do
    get "user-approvals", to: "admins#user_approvals", as: :user_approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
  end


  root 'places#index'
end
