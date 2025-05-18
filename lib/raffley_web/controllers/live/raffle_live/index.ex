defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <div class="raffles">
        <%= for raffle <- @raffles do %>
          <div class="card">
            <img src={raffle.image_path} />

            <h2>
              {raffle.prize}
            </h2>
            <div class="details">
              <div class="price">
                ${raffle.ticket_prize} / ticket
              </div>
              <div class="badge">
                {raffle.status}
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
