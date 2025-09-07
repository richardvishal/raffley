defmodule RaffleyWeb.PageControllerTest do
  use RaffleyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Raffley · Phoenix Framework"
  end
end
