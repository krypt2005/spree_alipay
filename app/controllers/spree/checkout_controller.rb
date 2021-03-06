module Spree
  class CheckoutController  < Spree::CheckoutController
  before_filter :redirect_for_alipay, :only => :update

  private

    def redirect_for_alipay
       return unless params[:state] == "payment"
        if params[:order][:payments_attributes].present?
        @payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
        end
        if @payment_method && @payment_method.kind_of?(Spree::PaymentMethod::Alipay)
         # @order.update_attributes(object_params)
          redirect_to gateway_alipay_path(:gateway_id => @payment_method.id, :id => @order.number)
        end
    end
end
end
