defmodule RaffleyWeb.AdminRaffleLive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Admin
  import RaffleyWeb.CustomComponent
  on_mount {RaffleyWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :page_title, "Listing Raffles")
      |> stream(:raffles, Admin.list_raffles())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          # 1 -> css transition classes
          # 2 -> starting transition classes
          # 3 -> ending transition classes
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
          # default -> 200
          time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div id="joke" class="joke hidden">
        What's the tree's favorite drink, {@current_user.username}?
      </div>
      <.header class="mt-6 ">
        {@page_title}
        <:actions>
          <.link class="button" navigate={~p"/admin/raffles/new"}>New Raffle</.link>
        </:actions>
      </.header>

      <.table
        id="raffles"
        rows={@streams.raffles}
        row_click={fn {_dom_id, raffle} -> JS.navigate(~p"/raffles/#{raffle}") end}
      >
        <:col :let={{_dom_id, raffle}} label="Prize">
          <.link navigate={~p"/raffles/#{raffle}"}>{raffle.prize}</.link>
        </:col>
        <:col :let={{_dom_id, raffle}} label="Status">
          <.badge status={raffle.status} />
        </:col>

        <:col :let={{_dom_id, raffle}} label="Ticket Price">{raffle.ticket_price}</:col>
        <:action :let={{_dom_id, raffle}}>
          <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>Edit</.link>
        </:action>
        <:action :let={{dom_id, raffle}}>
          <.link phx-click={delete_and_hide(dom_id, raffle)} data-confirm="Are you sure?">
            <.icon name="hero-trash" class="h-4 w-4" /> Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)
    {:ok, _} = Admin.delete_raffle(raffle)
    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  defp delete_and_hide(dom_id, raffle) do
    JS.push("delete", value: %{id: raffle.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
