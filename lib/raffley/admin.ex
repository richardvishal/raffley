defmodule Raffley.Admin do
  alias Raffley.Raffles
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  def change_raffle(%Raffle{} = raffle, attrs \\ %{}) do
    raffle
    |> Raffle.changeset(attrs)
  end

  def get_raffle!(id), do: Repo.get!(Raffle, id)

  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, raffle} ->
        raffle = Repo.preload(raffle, [:charity, :winning_ticket])
        Raffles.broadcast(raffle.id, {:raffle_updated, raffle})
        {:ok, raffle}

      {:error, _} = error ->
        error
    end
  end

  def delete_raffle(%Raffle{} = raffle) do
    Repo.delete(raffle)
  end

  def draw_winner(%Raffle{status: :closed} = raffle) do
    # if raffle has lot of tickets and concern about performance we can use this
    # winner =
    #   raffle
    #   |> Ecto.assoc(:tickets)
    #   |> order_by(fragment("RANDOM()"))
    #   |> limit(1)
    #   |> Repo.one()

    # case winner do
    #   nil ->
    #     {:error, "No tickets to draw!"}

    #   winner ->
    #     _

    #     {:ok, _raffle} =
    #       update_raffle(raffle, %{
    #         winning_ticket_id: winner.id
    #       })
    # end

    raffle = Repo.preload(raffle, :tickets)

    case raffle.tickets do
      [] ->
        {:error, "No tickets to draw!"}

      tickets ->
        winner = Enum.random(tickets)
        {:ok, _raffle} = update_raffle(raffle, %{winning_ticket_id: winner.id})
    end
  end

  def draw_winner(_raffle), do: {:error, "Raffle must be closed to draw winner!"}
end
