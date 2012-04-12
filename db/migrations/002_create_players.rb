Sequel.migration do
  up do
    create_table(:players) do
      primary_key :id
      String :user
    end
  end

  down do
    drop_table(:players)
  end
end
