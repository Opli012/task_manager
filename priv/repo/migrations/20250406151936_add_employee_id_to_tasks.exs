defmodule TaskManager.Repo.Migrations.AddEmployeeIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :employee_id, references(:employees, on_delete: :nothing)
    end

    create index(:tasks, [:employee_id])
  end
end
