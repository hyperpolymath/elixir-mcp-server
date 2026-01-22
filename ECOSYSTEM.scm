(ecosystem
  (version "0.1.0")
  (name "elixir-mcp-server")
  (type "library")
  (purpose "Model Context Protocol (MCP) server framework for Elixir/BEAM applications")
  
  (position-in-ecosystem
    "Reusable MCP protocol implementation that other hyperpolymath Elixir projects depend on")
  
  (related-projects
    ((project "feedback-o-tron")
     (relationship "potential-consumer")
     (reason "Will use this library for MCP integration"))
    
    ((project "observatory")
     (relationship "potential-consumer")
     (reason "GitHub intelligence platform that could expose MCP tools"))
    
    ((project "neurophone")
     (relationship "potential-consumer")
     (reason "Elixir/Phoenix app that could integrate with Claude Code"))
    
    ((project "claude-code")
     (relationship "inspiration")
     (reason "Target MCP client this framework integrates with")))
  
  (what-this-is
    "A complete, production-ready implementation of the Model Context Protocol (MCP) for Elixir. Provides JSON-RPC 2.0, stdio transport, and type-safe behaviors for defining tools, resources, and prompts.")
  
  (what-this-is-not
    "Not an MCP client. Not specific to any particular application domain. Not a standalone executable (it's a library)."))
