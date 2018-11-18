Rails.application.routes.draw do
  
  get 'friendships/create'

  get 'friendships/update'

  get 'friendships/destroy'

  #root :to => redirect('/activity/index')
  root 'application#index'

  
  get 'activity/index'
  delete 'activity/delete'
  get 'activity/edit'
  post 'activity/update'
  post 'activity/create'
  get 'activity/getNewActivities'
  post 'activity/getActivity'
  get 'activity_type/new'
  get 'activity_type/index'
  get 'activity_type/edit'
  post 'activity_type/getActivityType'
  post 'activity_type/create'
  post 'activity_type/verify'
  post 'activity_type/update'
  get 'group/index'
  get 'group/new'
  post 'group/create'
  get 'group/edit'
  patch 'group/update'
  delete 'group/delete'
  get 'group/show'
  get 'group/view'
  patch 'group/join'
  patch 'group/leave'
  patch 'group/kick'
  patch 'group/makeadmin'
  post 'group/submitmessage'
  get 'group/getNewMessage'
  post 'group/verifyUserCanBeAddedToGroup'
  post 'group/createNewInvite'
  get 'group/getInviteMessage'
  post 'group/rejectInvite'
  post 'group/acceptInvite'
  post 'group/requestNewInvite'
  post 'group/acceptRequest'
  post 'group/rejectRequest'
  
  get 'application/index'
  get 'application/privacy_policy'
  
  get 'profile/show'
  post 'profile/update'
  
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :conversations do
    resources :messages
    
    collection do
      get :inbox
      get :all, action: :index
      get :sent
      get :trash
      get :new
    end
  end
  resources :friendships, only: [:create, :update, :destroy]
  #devise_for :users
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
