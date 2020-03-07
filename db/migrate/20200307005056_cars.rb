class Cars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |c|
      c.integer :user
      c.string :make
      c.string :model
      c.string :range
    end
  end
end
