class CreateImports < ActiveRecord::Migration[5.1]
  def up
    create_table :imports do |t|
      t.boolean :create_category
      t.boolean :override_existing
      t.boolean :notify_on_finish
      t.attachment :file

      t.timestamps
    end
  end

  def down
    drop_table :imports
  end
end
