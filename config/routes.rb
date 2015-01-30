
  Spree::Core::Engine.routes.draw do
 
  namespace :gateway do
    get '/:gateway_id/alipay/:id' => 'alipay#show',     :as => :alipay
    get '/alipay/:id/comeback'    => 'alipay#comeback', :as => :alipay_comeback
  end
end
  
  

