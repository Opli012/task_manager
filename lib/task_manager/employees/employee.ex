defmodule TaskManager.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :name, :string
    field :email, :string

    has_many :tasks, TaskManager.Tasks.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
