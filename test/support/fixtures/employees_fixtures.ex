defmodule TaskManager.EmployeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManager.Employees` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> TaskManager.Employees.create_employee()

    employee
  end
end
