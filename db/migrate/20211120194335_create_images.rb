class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.belongs_to :user
      t.string :url

      t.timestamps
    end
  end
end
