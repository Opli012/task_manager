defmodule TaskManager.Repo.Migrations.AddPriorityToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :priority, :string
    end
  end
end
