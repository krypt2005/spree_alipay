require 'base64'
require 'digest/md5'
require 'spree_alipay/rc4'

module Spree
  class Gateway::AlipayController < Spree::StoreController
    helper 'spree/orders'
    skip_before_filter :verify_authenticity_token, :only => [:comeback]

    # Show form Alipay for payment
    def show
      load_order
      @order.payments.destroy_all
      @hash = Digest::MD5.hexdigest([@gateway.preferred_secret_key, @gateway.preferred_account_id, 
      @order.total.to_s, @order.number, [gateway_alipay_comeback_url(@order),'DR={DR}'].join('?'), @gateway.preferred_mode].join('|'))
      payment = @order.payments.create!(:amount => 0,  :payment_method_id => @gateway.id)
       if @order.blank? || @gateway.blank?
        flash[:error] = Spree.t(:invalid_arguments)
        redirect_to :back
      else
        @bill_address, @ship_address =  @order.bill_address, (@order.ship_address || @order.bill_address)
        render :action => :show
      end
    end


				
    def comeback
      load_order
      @data = params[:RespCode]
      if  @data.present?  && @data == "00"
       
        alipay_payment_success
        
        redirect_to order_url(@order, {:checkout_complete => true, :token => @order.token}), :notice => Spree.t(:payment_success)
      else
        flash[:error] = Spree.t(:alipay_payment_response_error, {:error_message => @data["ResponseMessage"]})
        redirect_to (@order.blank? ? root_url : edit_order_url(@order, {:token => @order.token}))
      end

    end
    
    


    private
      def load_order
        @order   = current_order || Spree::Order.find_by_number(params[:id])
        @gateway = params[:gateway_id].blank? ? @order.payments.last.payment_method : @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }
      end

     

      # save the payment record and complete the order
      def alipay_payment_success
        source = Spree::Alipayinfo.create(:first_name => @order.bill_address.firstname, :last_name => @order.bill_address.lastname, :transaction_id => @data["TransactionID"], :payment_id => @data["PaymentID"], :amount => @data["Amount"], :order_id => @order.id)

        alipay_payment_method = Spree::PaymentMethod::Alipay.last
        payment = @order.payments.where(:payment_method_id => alipay_payment_method.id).first
        payment = @order.payments.create!(:amount => 0,  :payment_method_id => alipay_payment_method.id) if payment.blank?
        payment.source = source
        payment.amount = source.amount
        payment.response_code = @data["ResponseCode"]
        payment.avs_response = @data["ResponseMessage"]
        payment.save
        payment.complete!

        @order.reload
        @order.next
        @order.state = 'complete'
        @order.save
        
        session[:order_id] = nil
        
        @order.finalize!
      end

    end
end
