defmodule Raffley.Repo.Migrations.CreateRaffles do
  use Ecto.Migration

  def change do
    create table(:raffles) do
      add :prize, :string
      add :description, :text
      add :ticket_prize, :integer
      add :status, :string
      add :image_path, :string

      timestamps(type: :utc_datetime)
    end
  end
end
