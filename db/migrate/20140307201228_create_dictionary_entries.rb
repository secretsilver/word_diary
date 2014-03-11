class CreateDictionaryEntries < ActiveRecord::Migration
  def change
    create_table :dictionary_entries do |t|
      t.string :word
      t.text   :definitions
    end
  end
end
