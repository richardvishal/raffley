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

  def create(conn, %{"raffle" => raffle_params}) do
    case Admin.create_raffle(raffle_params) do
      {:ok, raffle} ->
        conn
        |> put_status(:created)
        |> put_req_header("location", ~p"/api/raffles/#{raffle}")
        |> render(:show, raffle: raffle)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: RaffleyWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end
end
