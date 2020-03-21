class MySuperchargers < ActiveRecord::Migration[5.1]
  def change
    create_table :my_superchargers do |c|
      c.integer :user_id
      c.string :name
      c.string :street
      c.string :city
      c.string :state
      c.string :zip
      c.string :country
      c.integer :stalls
      c.integer :power
      c.float :latitude
      c.float :longitude
    end
  end
end
