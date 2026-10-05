class CreateMentions < ActiveRecord::Migration[8.0]
  def change
    create_table :mentions do |t|
      t.belongs_to :sender, null: false, foreign_key: { to_table: :reports }
      t.belongs_to :receiver, null: false, foreign_key: { to_table: :reports }
      t.index [:sender_id, :receiver_id], unique: true

      t.timestamps
    end
  end
end
