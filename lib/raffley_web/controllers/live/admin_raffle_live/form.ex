defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :page_title, "New Raffle") |> assign(:form, to_form(%{}, as: "raffle"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="raffle-form">
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:ticket_price]} label="Ticket Price" />
      <.input
        field={@form[:status]}
        type="select"
        prompt="Select Status"
        options={[:upcoming, :open, :closed]}
        label="Status"
      />
      <.input field={@form[:description]} type="textarea" label="Description" />
      <.input field={@form[:image_path]} label="Image Path" />
      <:actions>
        <.button>Save Raffle</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/raffles"}>Back</.back>
    """
  end
end
