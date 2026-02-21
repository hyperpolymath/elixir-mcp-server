<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- TOPOLOGY.md — Project architecture map and completion dashboard -->
<!-- Last updated: 2026-02-19 -->

# elixir-mcp-server — Project Topology

## System Architecture

```
                        ┌─────────────────────────────────────────┐
                        │              MCP CLIENT                 │
                        │        (Claude Code, etc.)              │
                        └───────────────────┬─────────────────────┘
                                            │ JSON-RPC 2.0 / stdio
                                            ▼
                        ┌─────────────────────────────────────────┐
                        │           ELIXIR MCP SERVER             │
                        │    (GenServer, Protocol handling)       │
                        └──────────┬───────────────────┬──────────┘
                                   │                   │
                                   ▼                   ▼
                        ┌───────────────────────┐  ┌────────────────────────────────┐
                        │ PLUGGABLE HANDLERS    │  │ SUPERVISION TREE               │
                        │ - Tools Registry      │  │ - Server Process               │
                        │ - Resource Serving    │  │ - Session Management           │
                        │ - Prompt Templates    │  │ - Connection Monitor           │
                        └──────────┬────────────┘  └──────────┬─────────────────────┘
                                   │                          │
                                   └────────────┬─────────────┘
                                                ▼
                        ┌─────────────────────────────────────────┐
                        │           APPLICATION LOGIC             │
                        │      (Your Elixir Application)          │
                        └─────────────────────────────────────────┘

                        ┌─────────────────────────────────────────┐
                        │          REPO INFRASTRUCTURE            │
                        │  Justfile / mix.exs .machine_readable/  │
                        │  ExUnit Tests       HexDocs             │
                        └─────────────────────────────────────────┘
```

## Completion Dashboard

```
COMPONENT                          STATUS              NOTES
─────────────────────────────────  ──────────────────  ─────────────────────────────────
PROTOCOL CORE
  JSON-RPC 2.0 implementation       ██████████ 100%    Production ready
  stdio Transport                   ██████████ 100%    Standard MCP verified
  Session Management                ██████████ 100%    Stateful interactions stable
  Capabilities Negotiation          ██████████ 100%    Handshake verified

HANDLERS & TOOLS
  Tool Registration (Behavior)      ██████████ 100%    Type-safe definitions active
  Resource Serving                  ████░░░░░░  40%    Initial implementation
  Prompt Templates                  ████░░░░░░  40%    Basic templates active

REPO INFRASTRUCTURE
  Justfile                          ██████████ 100%    Standard build tasks
  ExUnit Test Suite                 ██████████ 100%    Full protocol coverage
  .machine_readable/                ██████████ 100%    STATE.a2ml tracking

─────────────────────────────────────────────────────────────────────────────
OVERALL:                            ████████░░  ~80%   Framework stable, features expanding
```

## Key Dependencies

```
stdio Stream ───► Server GenServer ───► Tool Executor ───► App Logic
     │                 │                   │
     ▼                 ▼                   ▼
 JSON-RPC ────────► Schema Validation ──► Response
```

## Update Protocol

This file is maintained by both humans and AI agents. When updating:

1. **After completing a component**: Change its bar and percentage
2. **After adding a component**: Add a new row in the appropriate section
3. **After architectural changes**: Update the ASCII diagram
4. **Date**: Update the `Last updated` comment at the top of this file

Progress bars use: `█` (filled) and `░` (empty), 10 characters wide.
Percentages: 0%, 10%, 20%, ... 100% (in 10% increments).
