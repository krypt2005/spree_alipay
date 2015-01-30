module Spree
  class PaymentMethod::Alipay < PaymentMethod

    preference :account_id,    :string
    preference :url,           :string, :default =>  "https://pay.veritrans-link.com/epayment/payment"
    preference :secret_key,    :string
    preference :mode,          :string
    preference :currency_code, :string

    def payment_profiles_supported?
      false
    end
  end
end
