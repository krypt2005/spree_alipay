class CreateAlipayinfos < ActiveRecord::Migration
  def change
    create_table :spree_alipayinfos do |t|
      t.string :first_name
      t.string :last_name
      t.string :transaction_id
      t.string :payment_id
      t.decimal :amount
      t.integer :order_id

      t.timestamps
    end
  end
end
