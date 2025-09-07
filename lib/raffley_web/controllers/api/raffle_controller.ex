defmodule RaffleyWeb.Api.RaffleController do
  use RaffleyWeb, :controller
  alias Raffley.Admin

  def index(conn, _params) do
    render(conn, %{raffles: Admin.list_raffles()})
  end

  def show(conn, %{"id" => id}) do
    render(conn, %{raffle: Admin.get_raffle!(id)})
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: RaffleyWeb.ErrorJSON)
      |> render(:"404")
  end
end
