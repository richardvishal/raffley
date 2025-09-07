defmodule RaffleyWeb.Api.RaffleJSON do
  def index(%{raffles: raffles}) do
    %{
      raffles:
        for(
          raffle <- raffles,
          do: data(raffle)
        )
    }
  end

  def show(%{raffle: raffle}) do
    %{
      raffle: data(raffle)
    }
  end

  defp data(raffle) do
    %{
      id: raffle.id,
      status: raffle.status,
      description: raffle.description,
      ticket_price: raffle.ticket_price
    }
  end
end
