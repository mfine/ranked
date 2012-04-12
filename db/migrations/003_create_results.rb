Sequel.migration do
  up do
    create_table(:players) do
      primary_key :id
#     column :attrs, :hstore
    end
  end
  down do
    drop_table(:players)
  end
end
