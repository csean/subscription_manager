class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.date :start_date
      t.string :token
      t.references :item, index: true
      t.references :subscriber, index: true
      t.timestamps
    end
  end
end
