Sequel.migration do
  up do
    create_table(:results) do
      primary_key :id
#     column :attrs, :hstore
    end
  end
  down do
    drop_table(:results)
  end
end
