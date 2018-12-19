defmodule Breadcrumbs.Application do
  @moduledoc false
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    pool_size = get_config()

    children = [
      worker(Breadcrumbs.Pool, [pool_size]),
      worker(Breadcrumbs.PoolIndex, [pool_size])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: __MODULE__])
  end

  defp get_config do
    specified = Application.get_env(:breadcrumbs, :pool_size)

    case specified do
      nil -> 4
      0 -> raise Breadcrumbs.ConfigError, message: "Pool size cannot be 0"
      val -> val
    end
  end
end
