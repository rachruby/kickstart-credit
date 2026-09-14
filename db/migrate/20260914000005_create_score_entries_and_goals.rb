class CreateScoreEntriesAndGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :score_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :score, null: false
      t.date    :recorded_on, null: false
      t.timestamps
    end
    add_index :score_entries, [:user_id, :recorded_on], unique: true

    create_table :score_goals do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :target_score, null: false
      t.date    :target_date, null: false
      t.timestamps
    end
  end
end
