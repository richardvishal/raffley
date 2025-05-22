defmodule Raffley.Raffle do
  defstruct [:id, :prize, :ticket_prize, :status, :image_path, :description]
end

defmodule Raffley.Raffles do
  alias Raffley.Raffle

  def list_raffles do
    [
      %Raffle{
        id: 1,
        prize: "Autographed Jersey",
        ticket_prize: 2,
        status: :open,
        image_path: "/images/jersey.jpg",
        description: "Step up,  sports fans!"
      },
      %Raffle{
        id: 2,
        prize: "Coffee with a Yeti",
        ticket_prize: 3,
        status: :upcoming,
        image_path: "/images/yeti-coffee.jpg",
        description: "A super-chill coffee date."
      },
      %Raffle{
        id: 3,
        prize: "Vintage Comic Book",
        ticket_prize: 1,
        status: :closed,
        image_path: "/images/comic-book.jpg",
        description: "A race collectible!"
      }
    ]
  end

  def get_raffle!(id) when is_integer(id) do
    Enum.find(list_raffles(), &(&1.id == id))
  end

  def get_raffle!(id) when is_binary(id) do
    id |> String.to_integer() |> get_raffle!
  end

  def featured_raffles(raffle) do
    list_raffles() |> List.delete(raffle)
  end
end
