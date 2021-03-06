Rails.application.routes.draw do
  resources :outgoing_receipt_details

  resources :incoming_receipt_details

  resources :outgoing_receipts do
    get 'add_si', on: :new
    get 'add_dr', on: :new
    collection do
      get 'sales_invoices'
      get 'deliveries'
    end
  end

  resources :incoming_receipts

  resources :inventories

  resources :items do
    collection do
      get 'descriptions'
      get 'part_numbers'
      get 'ajaxList'
      get 'merging'
    end
    member do
      get 'getStock'
      get 'getUnitPrice'
      put 'merge'
    end
  end

  devise_for :users

  get 'generate_report' => 'dashboard#generate_report'
  post 'generate_report' => 'dashboard#generate_report'
  get 'generate_bill' => 'dashboard#generate_bill'
  get 'archive' => 'dashboard#archive'
  post 'archive' => 'dashboard#archive'

  get 'stock_report' => 'reports#stocks'
  get 'delivery_report' => 'reports#deliveries'
  get 'si_report' => 'reports#sis'
  get 'dr_report' => 'reports#drs'
  get 'bill' => 'reports#bill'
  post 'bill' => 'reports#bill'

  root 'dashboard#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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

  # You can have the root of your site routed with "root"
end
