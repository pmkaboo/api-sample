class CreateGroupEvent < ActiveRecord::Migration[6.0]
  def change
    create_table :group_events do |t|
      t.date :start_at
      t.date :end_at
      t.integer :duration
      t.string :name
      t.text :description
      t.string :location
      t.boolean :published
      t.datetime :deleted_at
    end
  end
end
