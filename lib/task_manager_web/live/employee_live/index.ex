defmodule TaskManagerWeb.EmployeeLive.Index do
  use TaskManagerWeb, :live_view

  alias TaskManager.Employees
  alias TaskManager.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :employees, Employees.list_employees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Employee")
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Employee")
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Employees")
    |> assign(:employee, nil)
  end

  @impl true
  def handle_info({TaskManagerWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employees, employee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)

    {:noreply, stream_delete(socket, :employees, employee)}
  end
end
