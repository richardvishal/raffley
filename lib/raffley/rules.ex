defmodule Raffley.Rules do
  def list_rules do
    [
      %{
        id: 1,
        text: "Participant must have a high tolerance for puns and dad jokes."
      },
      %{
        id: 2,
        text: " Winner must do a victory dance when calming  their prize.🕺"
      },
      %{
        id: 3,
        text: "Have fun. 🎟️"
      }
    ]
  end

  def get_rule!(id) when is_integer(id) do
    Enum.find(list_rules(), &(&1.id == id))
  end

  def get_rule!(id) when is_binary(id) do
    id |> String.to_integer() |> get_rule!
  end
end
