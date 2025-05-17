defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, ticket: 0, price: 3)
    IO.inspect(socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="estimator">
      <h1>
        Raffle Estimator
      </h1>
      <section>
        <button phx-click="add" phx-value-quantity="5">
          +
        </button>
        <div>
          {@ticket}
        </div>
        @
        <div>
          ${@price}
        </div>
        =
        <div>
          ${@ticket * @price}
        </div>
      </section>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity} = _unsigned_params, socket) do
    # socket = assign(socket, ticket: socket.assigns.ticket + 1)
    socket = update(socket, :ticket, &(&1 + String.to_integer(quantity)))
    IO.inspect(socket)
    {:noreply, socket}
  end
end
