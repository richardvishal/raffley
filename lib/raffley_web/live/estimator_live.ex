defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 2000)

    socket = assign(socket, ticket: 0, price: 3, page_title: "Estimator")
    IO.inspect(self(), label: "MOUNT")

    # IO.inspect(socket)
    # {:ok, socket, layout: {RaffleyWeb.Layouts, :simple}}
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

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

      <form phx-submit="set-price">
        <label>Ticket Price:</label>
        <input type="text" name="price" value={@price} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity} = _unsigned_params, socket) do
    IO.inspect(self(), label: "EVENT")

    # socket = assign(socket, ticket: socket.assigns.ticket + 1)
    socket = update(socket, :ticket, &(&1 + String.to_integer(quantity)))
    # raise "💥"
    # IO.inspect(socket)
    {:noreply, socket}
  end

  def handle_event("set-price", %{"price" => price}, socket) do
    socket = assign(socket, :price, String.to_integer(price))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :ticket, &(&1 + 10))}
  end
end
