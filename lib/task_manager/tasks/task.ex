defmodule TaskManager.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    field :title, :string
    field :completed, :boolean, default: false

    belongs_to :employee, TaskManager.Employees.Employee

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :employee_id])
    |> validate_required([:title, :description, :completed, :employee_id])
  end
end
