defmodule ElixirMcpServer.Protocol do
  @moduledoc """
  JSON-RPC 2.0 protocol implementation for the Model Context Protocol (MCP).

  This module provides low-level encoding and decoding of JSON-RPC messages,
  ensuring compliance with the MCP specification (Version 2024-11-05).
  """

  @jsonrpc_version "2.0"

  @doc """
  Encodes a JSON-RPC request.
  
  Used when the server needs to send a request or notification to the client.
  """
  def encode_request(method, params, id) do
    %{
      "jsonrpc" => @jsonrpc_version,
      "method" => method,
      "params" => params,
      "id" => id
    }
    |> Jason.encode!()
  end

  @doc """
  Encodes a successful JSON-RPC response.
  
  The `result` map should contain the method-specific response data.
  """
  def encode_response(result, id) do
    %{
      "jsonrpc" => @jsonrpc_version,
      "result" => result,
      "id" => id
    }
    |> Jason.encode!()
  end

  @doc """
  Encodes a JSON-RPC error response.
  
  Parameters:
  - `code`: Integer error code (standard JSON-RPC or MCP specific).
  - `message`: Human-readable error summary.
  - `id`: The ID of the request that caused the error.
  - `data`: Optional additional error context.
  """
  def encode_error(code, message, id, data \\ nil) do
    error = %{
      "code" => code,
      "message" => message
    }

    error = if data, do: Map.put(error, "data", data), else: error

    %{
      "jsonrpc" => @jsonrpc_version,
      "error" => error,
      "id" => id
    }
    |> Jason.encode!()
  end

  @doc """
  Decodes a raw JSON string into a JSON-RPC message map.
  
  Validates that the `jsonrpc` version is exactly "2.0".
  """
  def decode(json) do
    case Jason.decode(json) do
      {:ok, %{"jsonrpc" => "2.0"} = msg} -> {:ok, msg}
      {:ok, _} -> {:error, :invalid_jsonrpc_version}
      {:error, _} = error -> error
    end
  end
end
