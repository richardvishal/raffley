defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles

  def mount(_params, _session, socket) do
    socket = stream(socket, :raffles, Raffles.list_raffles())
    IO.inspect(socket.assigns.streams, label: "MOUNT")

    socket =
      attach_hook(socket, :log_stream, :after_render, fn
        socket ->
          # inspect the stream
          IO.inspect(socket.assigns.streams, label: "After Render")
          socket
      end)

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
      <div class="raffles" id="raffles" phx-update="stream">
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
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
end
