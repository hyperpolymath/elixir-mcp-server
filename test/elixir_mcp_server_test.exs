# SPDX-License-Identifier: MPL-2.0
# Copyright (c) Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
defmodule ElixirMcpServerTest do
  use ExUnit.Case
  doctest ElixirMcpServer

  test "greets the world" do
    assert ElixirMcpServer.hello() == :world
  end
end
