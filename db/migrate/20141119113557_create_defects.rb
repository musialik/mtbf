class CreateDefects < ActiveRecord::Migration
  def change
    create_table :defects do |t|
      t.references :machine, index: true
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps
    end
  end
end
