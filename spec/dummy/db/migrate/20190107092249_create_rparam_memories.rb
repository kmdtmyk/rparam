class CreateRparamMemories < ActiveRecord::Migration[5.2]
  def change
    create_table :rparam_memories do |t|
      t.references :user, polymorphic: true, index: true
      t.string :action
      t.text :value

      t.timestamps
    end
  end
end
