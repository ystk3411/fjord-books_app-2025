class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
