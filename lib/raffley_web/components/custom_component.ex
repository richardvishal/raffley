defmodule RaffleyWeb.CustomComponent do
  use Phoenix.Component

  attr :status, :atom, required: true

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border ",
      @status == :open && "text-lime-600 border-lime-600",
      @status == :upcoming && "text-amber-600 border-amber-600",
      @status == :closed && "text-gray-600 border-lime-600"
    ]}>
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(🥳 😉 😏) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <%!-- :if={@details != []} --%>
      <div :for={detail <- @details} class="details">
        {render_slot(detail, @emoji)}
      </div>
    </div>
    """
  end
end
