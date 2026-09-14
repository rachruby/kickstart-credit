class CreateCreditAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :credit_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :name, null: false
      t.integer :credit_limit_cents, null: false
      t.integer :balance_cents, null: false, default: 0
      t.date    :opened_on, null: false
      t.string  :status, null: false, default: "active"
      t.timestamps
    end
  end
end
