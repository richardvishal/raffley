defmodule RaffleyWeb.CharityLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Charities

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        Charity {@charity.id}
        <:subtitle>This is a charity record from your database.</:subtitle>
        <:actions>
          <.link class="button" navigate={~p"/charities"}>
            <.icon name="hero-arrow-left" />
          </.link>
          <.link class="button" navigate={~p"/charities/#{@charity}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit charity
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@charity.name}</:item>
        <:item title="Slug">{@charity.slug}</:item>
      </.list>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Charity")
     |> assign(:charity, Charities.get_charity!(id))}
  end
end
