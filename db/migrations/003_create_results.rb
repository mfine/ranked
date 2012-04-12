Sequel.migration do
  up do
    create_table(:results) do
      primary_key :id
      Integer :winner_id
      Integer :loser_id
    end
  end
  down do
    drop_table(:results)
  end
end
