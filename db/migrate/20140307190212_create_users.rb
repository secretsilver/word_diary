class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :twitter_id
    end
  end
end
