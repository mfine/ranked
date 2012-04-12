Sequel.migration do
  up do
    create_table(:players) do
      primary_key :id
      column :user, "text", unique: true
    end
  end

  down do
    drop_table(:players)
  end
end
