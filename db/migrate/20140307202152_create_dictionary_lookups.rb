class CreateDictionaryLookups < ActiveRecord::Migration
  def change
    create_table :dictionary_lookups do |t|
      t.integer   :user_id
      t.integer   :dictionary_entry_id
      t.datetime  :learned_at
    end
  end
end
