Sequel.migration do
  up do
    add_column :players, :name, String
  end

  down do
    drop_column :players, :name
  end
end

