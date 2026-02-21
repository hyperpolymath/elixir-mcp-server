defmodule ElixirMcpServer.Tool do
  @moduledoc """
  Behavior definition for MCP Tools.

  Any module that provides an executable function to an MCP client MUST 
  implement this behavior. It defines the contract for how tools are 
  discovered (name, description, schema) and executed.

  ## Required Callbacks

  - `name/0`: Must return a unique alphanumeric string (snake_case preferred).
  - `description/0`: A concise summary used by the LLM to decide when to call the tool.
  - `input_schema/0`: A JSON Schema (as a Map) defining the tool's parameters.
  - `execute/2`: The core logic. Must return `{:ok, content_list}` or `{:error, reason}`.

  ## Execution Return Format

  The `content_list` should contain maps representing content blocks:
  ```elixir
  [
    %{type: "text", text: "Results go here..."}
  ]
  ```
  """

  @doc """
  Returns the tool name. Must be unique within the server instance.
  """
  @callback name() :: String.t()

  @doc """
  Returns a human-readable description of the tool's purpose and side effects.
  """
  @callback description() :: String.t()

  @doc """
  Returns the JSON Schema map for the tool's input parameters.
  """
  @callback input_schema() :: map()

  @doc """
  Executes the tool logic.
  
  Arguments:
  - `args`: Map of user-supplied arguments (validated against the schema).
  - `context`: Reserved for future use (e.g., authentication tokens, trace IDs).
  """
  @callback execute(args :: map(), context :: map()) ::
              {:ok, [map()]} | {:error, term()}

  defmacro __using__(_opts) do
    quote do
      @behaviour ElixirMcpServer.Tool
    end
  end
end
