(define-module meta
  (architecture-decisions
    ((adr-001
      (status "accepted")
      (date "2026-01-22")
      (context "Need reusable MCP protocol implementation for Elixir projects")
      (decision "Create standalone library instead of embedding in each project")
      (consequences
        "Enables code reuse across feedback-o-tron, observatory, neurophone"
        "Requires proper versioning and API stability"
        "Can be published to Hex for wider Elixir community"))
    
    ((adr-002
      (status "accepted")
      (date "2026-01-22")
      (context "MCP protocol uses JSON-RPC 2.0 over stdio")
      (decision "Use Jason for JSON, GenServer for state, stdio for transport")
      (consequences
        "Standard Elixir patterns make code maintainable"
        "OTP supervision provides reliability"
        "stdio transport matches MCP specification"))
    
    ((adr-003
      (status "accepted")
      (date "2026-01-22")
      (context "Tools need type-safe definition with clear contracts")
      (decision "Use Elixir behaviors for Tool/Resource/Prompt definitions")
      (consequences
        "Compile-time checking of implementations"
        "Clear API contracts via @callback"
        "Easy to document and understand")))
  
  (development-practices
    (code-style "Standard Elixir with mix format")
    (security "Input validation, no shell execution, principle of least privilege")
    (testing "Unit tests with Mox for mocking, property tests with StreamData")
    (versioning "SemVer 2.0")
    (documentation "ExDoc with examples, behavior documentation")
    (branching "main branch, feature branches for new work"))
  
  (design-rationale
    (why-elixir
      "OTP provides reliability via supervision"
      "Pattern matching suits protocol parsing"
      "GenServer natural fit for stateful protocol server"
      "BEAM concurrency model handles multiple clients")
    
    (why-behaviors
      "Enforces consistent tool/resource API"
      "Provides compile-time contract checking"
      "Makes tooling discoverable")
    
    (why-separate-library
      "Avoid code duplication across projects"
      "Enable community contributions"
      "Provide stable API for hyperpolymath ecosystem")))
