class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.belongs_to :project
      t.datetime :deadline
      t.integer :priority, default: 0
      t.boolean :done, default: false
      t.timestamps
    end
  end
end
