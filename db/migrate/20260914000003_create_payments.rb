class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :credit_account, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.date    :due_on, null: false
      t.date    :paid_on
      t.string  :status, null: false, default: "scheduled"
      t.timestamps
    end
    add_index :payments, [:credit_account_id, :due_on]
  end
end
