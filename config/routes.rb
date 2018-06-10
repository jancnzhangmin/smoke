Rails.application.routes.draw do
  root 'logins#index'
  resources :mytests
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
      get 'test'
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
    resources :userdevides
  end
  resources :getopenids do
    collection do
      get 'getopenid'
    end
  end

  post '/', to: 'ygsubscribes#create'

  resources :apis do
    collection do
      get 'sign'
      get 'checkuserauth'
      get 'getuserinfo'
      get 'sendvercode'
      get 'bindphone'
      get 'changealertsms'
      get 'changealertswx'
      get 'checkdevice'
      get 'subscribedevice'
      get 'getdevicelist'
      get 'getsingledevice'
      get 'getuserdevicehisory'
      get 'binduser'
      get 'getchildrenuser'
      get 'getattchuserdetail'
      get 'getuserdevicelist'
      get 'bindattchuserdevice'
      get 'removedevice'
      get 'getdevicehistroydetail'
      get 'getcanbingdevicelist'
      get 'deletedevice'
      get 'getdevicebysn'
    end
  end
  resources :logins
  resources :admins do
    collection do
      get 'checkuser'
      get 'setauth'
    end
    member do
      get 'auth'
      post 'setauth'
    end
  end
  resources :roles
  resources :modifypwds
  resources :noauths


end
