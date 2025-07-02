defmodule TaskManagerWeb.Router do
  use TaskManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaskManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskManagerWeb do
    pipe_through :browser

    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit

    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit


    live "/employees", EmployeeLive.Index, :index
    live "/employees/new", EmployeeLive.Index, :new
    live "/employees/:id/edit", EmployeeLive.Index, :edit

    live "/employees/:id", EmployeeLive.Show, :show
    live "/employees/:id/show/edit", EmployeeLive.Show, :edit

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:task_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
