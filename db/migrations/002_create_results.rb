Sequel.migration do
  up do
    create_table(:results) do
      primary_key :id
      column :at, DateTime
      column :winner_id, "integer"
      column :loser_id, "integer"
    end
  end

  down do
    drop_table(:results)
  end
end
