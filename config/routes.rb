Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'devices#index'

  resources :mylogs do
    collection do
      post 'subscribe'
      post 'index'
    end
  end
  resources :tests do
    collection do
      post 'test'
    end
  end
  resources :configs
  resources :devices do
    resources :devicehistorylists
    member do
      get 'refreshdevice'
    end
  end
  resources :subscribedevices do
    collection do
      get 'getdevicesubscribeinfo'
    end
  end
  resources :devicemaps do
    collection do
      get 'getdevice'
    end
  end
  resources :messages
  resources :users do
    member do
      get 'attchuser'
      get 'attchdevice'
      get 'reldevice'
    end
    resources :reldevices
  end
end
