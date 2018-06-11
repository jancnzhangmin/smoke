Rails.application.routes.draw do
  root 'logins#index' #主页
  resources :mytests
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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
  resources :configs #设置
  resources :devices do #设备
    resources :devicehistorylists #设备历史
    member do
      get 'refreshdevice'
    end
  end
  resources :subscribedevices do #注册设备
    collection do
      get 'getdevicesubscribeinfo'
    end
  end
  resources :devicemaps do #设备地图
    collection do
      get 'getdevice'
    end
  end
  resources :messages #短信
  resources :users do #用户
    member do
      get 'attchuser'
      get 'attchdevice'
      get 'reldevice'
    end
    resources :reldevices #关联用户设备
    resources :userdevides #用户设备
  end
  resources :getopenids do
    collection do
      get 'getopenid'
    end
  end

  post '/', to: 'ygsubscribes#create' #Iot回调接口

  resources :apis do #微信端API接口
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
  resources :logins #登录
  resources :admins do #管理员
    collection do
      get 'checkuser'
      get 'setauth'
    end
    member do
      get 'auth'
      post 'setauth'
    end
  end
  resources :roles #管理权限
  resources :modifypwds #修改密码
  resources :noauths


end
