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
    get "approvals", to: "admins#approvals", as: :approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    post "approve-place/:id", to: "admins#approve_place", as: :approve_place
    delete "reject-place/:id", to: "admins#reject_place", as: :reject_place
    post 'approve-place-edit/:id', to: "admins#approve_place_edit", as: :approve_place_edit
    delete 'reject-place-edit/:id', to: "admins#reject_place_edit", as: :reject_place_edit
    post 'approve-menu/:id', to: "admins#approve_menu", as: :approve_menu
    delete 'reject-menu/:id', to: "admins#reject_menu", as: :reject_menu
  end


  root 'places#index'
end
