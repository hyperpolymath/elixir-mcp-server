defmodule ElixirMcpServerTest do
  use ExUnit.Case
  doctest ElixirMcpServer

  test "greets the world" do
    assert ElixirMcpServer.hello() == :world
  end
end
