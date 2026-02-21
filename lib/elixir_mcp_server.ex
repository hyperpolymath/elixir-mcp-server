defmodule ElixirMcpServer do
  @moduledoc """
  Model Context Protocol (MCP) server framework for Elixir.

  This framework allows Elixir applications to provide tools and resources 
  to AI agents (like Claude) using the standard MCP JSON-RPC protocol.

  ## Primary Interface

  The `ElixirMcpServer` module provides the public API for managing the server 
  lifecycle and registering capabilities.

  ### Design Philosophy:
  - **Type Safety**: Leveraging Elixir's pattern matching and behaviors.
  - **Concurrency**: Using OTP GenServers to handle multiple simultaneous tool calls.
  - **Composability**: Allowing tools and resources to be defined as independent modules.

  ## Architecture Components

  - `ElixirMcpServer.Server`: The core state machine managing current protocol sessions.
  - `ElixirMcpServer.Protocol`: The serialization layer for JSON-RPC 2.0 messages.
  - `ElixirMcpServer.Tool`: The behavior contract for executable agent tools.
  - `ElixirMcpServer.Resource`: The behavior contract for serving data/configs.
  """

  alias ElixirMcpServer.Server

  @doc """
  Starts an MCP server instance.
  
  Options:
  - `:name` - Public name of the server.
  - `:version` - Semantic version string.
  - `:tools` - Initial list of tool modules.
  - `:resources` - Initial list of resource modules.
  """
  def start_link(opts) do
    Server.start_link(opts)
  end

  @doc """
  Registers a new tool module with the active server.
  This allows for dynamic extension of the agent's capabilities.
  """
  defdelegate register_tool(tool_module), to: Server

  @doc """
  Registers a new resource module with the active server.
  """
  defdelegate register_resource(resource_module), to: Server

  @doc """
  Terminates the server and cleans up resources.
  """
  defdelegate stop(), to: Server
end
