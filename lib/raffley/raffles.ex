defmodule Raffley.Raffles do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Repo.all(Raffle)
  end

  def filter_raffles(filter) do
    Raffle
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort_by(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(upcoming open closed),
    do: where(query, status: ^status)

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q), do: where(query, [r], ilike(r.prize, ^"%#{q}%"))

  defp sort_by(query, "prize") do
    order_by(query, :prize)
  end

  defp sort_by(query, "ticket_price_desc") do
    order_by(query, desc: :ticket_price)
  end

  defp sort_by(query, "ticket_price_asc") do
    order_by(query, asc: :ticket_price)
  end

  defp sort_by(query, _) do
    order_by(query, :id)
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def featured_raffles(raffle) do
    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end
end
