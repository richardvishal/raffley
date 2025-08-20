defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles

  def mount(_params, _session, socket) do
    # IO.inspect(socket.assigns.streams, label: "MOUNT")

    # form = to_form(%{"q" => "", "status" => "open", "sort_by" => ""})
    socket = socket |> stream(:raffles, Raffles.list_raffles()) |> assign(:form, to_form(%{}))

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn
    #     socket ->
    #       # inspect the stream
    #       IO.inspect(socket.assigns.streams, label: "After Render")
    #       socket
    #   end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery Raffle Coming soon!
        <:details :let={vibe}>
          To be Revealed Tomorrow {vibe}
        </:details>
        <:details>
          Any Guesses?
        </:details>
      </.banner>
      <.filter_form form={@form} />

      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />
      <.input
        field={@form[:status]}
        type="select"
        options={[:upcoming, :open, :closed]}
        prompt="Status"
      />
      <.input
        field={@form[:sort_by]}
        type="select"
        options={[:prize, :ticket_price]}
        prompt="Sort By"
      />
    </.form>
    """
  end

  attr :raffle, Raffley.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def raffle_card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <img src={@raffle.image_path} />

        <h2>
          {@raffle.prize}
        </h2>
        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    # IO.inspect(params, label: "FILTER PARAMS")
    socket =
      assign(socket, :form, to_form(params))
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)

    {:noreply, socket}
  end
end
