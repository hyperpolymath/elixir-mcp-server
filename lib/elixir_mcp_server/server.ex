defmodule ElixirMcpServer.Server do
  @moduledoc """
  Main MCP server GenServer.

  This module manages the server state, handles message dispatch, 
  and orchestrates the transport layer (currently stdio).
  """
  use GenServer
  require Logger

  alias ElixirMcpServer.Protocol

  # STATE:
  # - name: Server identity.
  # - version: Implementation version.
  # - tools: Map of {name => module} for registered tools.
  # - resources: Map of {uri => module} for registered resources.
  # - capabilities: MCP capabilities advertised during initialization.
  defstruct [:name, :version, :tools, :resources, :transport, :capabilities]

  @doc """
  Starts the MCP server GenServer.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Dynamically registers a tool module with the running server.
  """
  def register_tool(tool_module) do
    GenServer.call(__MODULE__, {:register_tool, tool_module})
  end

  @doc """
  Dynamically registers a resource module with the running server.
  """
  def register_resource(resource_module) do
    GenServer.call(__MODULE__, {:register_resource, resource_module})
  end

  @doc """
  Stops the server.
  """
  def stop do
    GenServer.stop(__MODULE__)
  end

  @impl true
  def init(opts) do
    name = Keyword.fetch!(opts, :name)
    version = Keyword.fetch!(opts, :version)
    tools = Keyword.get(opts, :tools, [])
    resources = Keyword.get(opts, :resources, [])

    state = %__MODULE__{
      name: name,
      version: version,
      tools: build_tool_map(tools),
      resources: build_resource_map(resources),
      capabilities: %{
        tools: %{},
        resources: %{}
      }
    }

    {:ok, state, {:continue, :start_transport}}
  end

  @impl true
  def handle_continue(:start_transport, state) do
    # TRANSPORT: Start the stdio loop.
    # In MCP, stdio is the primary transport for CLI-integrated servers.
    spawn_link(fn -> stdio_loop(state) end)
    {:noreply, state}
  end

  @impl true
  def handle_call({:register_tool, tool_module}, _from, state) do
    tools = Map.put(state.tools, tool_module.name(), tool_module)
    {:reply, :ok, %{state | tools: tools}}
  end

  @impl true
  def handle_call({:register_resource, resource_module}, _from, state) do
    resources = Map.put(state.resources, resource_module.uri(), resource_module)
    {:reply, :ok, %{state | resources: resources}}
  end

  defp build_tool_map(tool_modules) do
    Enum.into(tool_modules, %{}, fn mod -> {mod.name(), mod} end)
  end

  defp build_resource_map(resource_modules) do
    Enum.into(resource_modules, %{}, fn mod -> {mod.uri(), mod} end)
  end

  # The stdio_loop reads from standard input line-by-line.
  defp stdio_loop(state) do
    case IO.read(:stdio, :line) do
      :eof ->
        :ok
      {:error, reason} ->
        Logger.error("stdio read error: #{inspect(reason)}")
      line ->
        handle_message(String.trim(line), state)
        stdio_loop(state)
    end
  end

  # DISPATCH: Handles individual MCP methods.
  defp handle_message(line, state) do
    case Protocol.decode(line) do
      # INITIALIZE: Sent by the client to negotiate protocol version and capabilities.
      {:ok, %{"method" => "initialize", "id" => id}} ->
        response = Protocol.encode_response(%{
          "protocolVersion" => "2024-11-05",
          "serverInfo" => %{
            "name" => state.name,
            "version" => state.version
          },
          "capabilities" => state.capabilities
        }, id)
        IO.puts(response)

      # TOOLS/LIST: Returns the inventory of available tools and their schemas.
      {:ok, %{"method" => "tools/list", "id" => id}} ->
        tools = Enum.map(state.tools, fn {_name, mod} ->
          %{
            "name" => mod.name(),
            "description" => mod.description(),
            "inputSchema" => mod.input_schema()
          }
        end)
        response = Protocol.encode_response(%{"tools" => tools}, id)
        IO.puts(response)

      # TOOLS/CALL: Executes a specific tool with user-provided arguments.
      {:ok, %{"method" => "tools/call", "params" => %{"name" => tool_name, "arguments" => args}, "id" => id}} ->
        case Map.get(state.tools, tool_name) do
          nil ->
            error = Protocol.encode_error(-32601, "Tool not found", id)
            IO.puts(error)
          tool_mod ->
            case tool_mod.execute(args, %{}) do
              {:ok, content} ->
                response = Protocol.encode_response(%{"content" => content}, id)
                IO.puts(response)
              {:error, reason} ->
                error = Protocol.encode_error(-32000, "Tool execution failed", id, reason)
                IO.puts(error)
            end
        end

      {:ok, _msg} ->
        :ok  # Ignore unknown/unsupported messages

      {:error, reason} ->
        Logger.error("Failed to decode message: #{inspect(reason)}")
    end
  end
end
