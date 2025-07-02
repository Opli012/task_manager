defmodule TaskManagerWeb.EmployeeLive.FormComponent do
  use TaskManagerWeb, :live_component

  alias TaskManager.Employees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage employee records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="employee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:email]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Employee</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Employees.change_employee(employee))
     end)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset = Employees.change_employee(socket.assigns.employee, employee_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    save_employee(socket, socket.assigns.action, employee_params)
  end

  defp save_employee(socket, :edit, employee_params) do
    case Employees.update_employee(socket.assigns.employee, employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Employees.create_employee(employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
