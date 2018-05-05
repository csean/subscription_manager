class AddInitialItem < SeedMigration::Migration
  def up
    Item.create!(name: Faker::Name.name, price_cents: 10000)
  end

  def down
    Item.destroy_all
  end
end
