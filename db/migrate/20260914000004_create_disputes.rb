class CreateDisputes < ActiveRecord::Migration[7.2]
  def change
    create_table :disputes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bureau, null: false
      t.string :item_description, null: false
      t.string :reason, null: false
      t.string :status, null: false, default: "draft"
      t.text   :letter_body
      t.text   :resolution_notes
      t.date   :submitted_on
      t.date   :resolved_on
      t.timestamps
    end
    add_index :disputes, :status
  end
end
