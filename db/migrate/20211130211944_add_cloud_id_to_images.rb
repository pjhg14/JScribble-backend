class AddCloudIdToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :cloud_id, :string
  end
end
