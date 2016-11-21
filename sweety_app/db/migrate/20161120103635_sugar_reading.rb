class SugarReading < ActiveRecord::Migration
  def change
  	create_table :sugar_readings do |t|
      t.belongs_to :user, index: true
      t.string :description
      t.integer :blood_sugar
      t.timestamps null: false
    end
  end
end
