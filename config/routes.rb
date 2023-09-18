# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :places do
    resources :menus
    collection do
      post :search
    end
  end

  get 'change-logs/new/:id', to: 'change_logs#new', as: :new_change_log
  post 'change-logs/:id', to: 'change_logs#create', as: :change_logs

  scope 'admin-panel' do
    get "user-approvals", to: "admins#user_approvals", as: :user_approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    get "place-approvals", to: "admins#list_place_edit", as: :place_approvals
    post "approve-place/:id", to: "admins#approve_place", as: :approve_place
    delete "reject-place/:id", to: "admins#reject_place", as: :reject_place
  end


  root 'places#index'
end
