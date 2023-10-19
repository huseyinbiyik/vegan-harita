# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :places do
    resources :reviews
    resources :menus
    collection do
      post :search
    end
  end

  get 'change-logs/place/:id', to: 'change_logs#new_place_edit', as: :new_place_edit
  post 'change-logs/:id', to: 'change_logs#create_place_edit', as: :create_place_edit
  get 'change-logs/menu/:place_id/:menu_id', to: 'change_logs#new_menu_edit', as: :new_menu_edit
  post 'change-logs/menu/place_id/:menu_id', to: 'change_logs#create_menu_edit', as: :create_menu_edit

  scope 'admin-panel' do
    get "approvals", to: "admins#approvals", as: :approvals
    post "approve-user/:id", to: "admins#approve_user", as: :approve_user
    post "approve-place/:id", to: "admins#approve_place", as: :approve_place
    delete "reject-place/:id", to: "admins#reject_place", as: :reject_place
    post 'approve-place-edit/:id', to: "admins#approve_place_edit", as: :approve_place_edit
    delete 'reject-place-edit/:id', to: "admins#reject_place_edit", as: :reject_place_edit
    post 'approve-menu/:id', to: "admins#approve_menu", as: :approve_menu
    delete 'reject-menu/:id', to: "admins#reject_menu", as: :reject_menu
    post 'approve-menu-edit/:id', to: "admins#approve_menu_edit", as: :approve_menu_edit
    delete 'reject-menu-edit/:id', to: "admins#reject_menu_edit", as: :reject_menu_edit
  end


  root 'places#index'
end
