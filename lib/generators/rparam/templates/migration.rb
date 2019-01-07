class CreateControllerParameters < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :controller_parameters do |t|
      t.references :user, foreign_key: true
      t.string :scope
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
