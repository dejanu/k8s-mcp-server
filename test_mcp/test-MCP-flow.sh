#!/usr/bin/env bash

# assuming the MCP server is running on localhost:8885/messages



# Print a command, then run it. Output of the command follows on stdout.
run() {
  printf '\n$ %s\n\n' "$1"
  eval "$1"
  printf '\n'
}

# Print a command without running it.
show() {
  printf '\n$ %s\n' "$1"
}

run 'curl -s http://localhost:8885/health'

# Start an MCP session. I speak protocol 2025-11-25. Here’s who I am (clientInfo: test)
# mcp-session-id comes back in the initialize response headers
read -r -d '' initialize_cmd <<'EOF' || true
curl -s -D - -X POST http://localhost:8885/messages \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "mcp-protocol-version: 2025-11-25" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-11-25",
      "capabilities": {},
      "clientInfo": {"name": "test", "version": "1.0"}
    }
  }'
EOF
printf '\n$ %s\n\n' "$initialize_cmd"
initialize_response=$(eval "$initialize_cmd")
printf '%s\n' "$initialize_response"
mcp_session_id=$(printf '%s\n' "$initialize_response" | awk 'tolower($1)=="mcp-session-id:" {print $2}' | tr -d '\r')
printf '\n# mcp_session_id=%s\n' "$mcp_session_id"

# initialized notification
run "curl -s -X POST http://localhost:8885/messages \\
  -H \"Content-Type: application/json\" \\
  -H \"Accept: application/json, text/event-stream\" \\
  -H \"mcp-protocol-version: 2025-11-25\" \\
  -H \"mcp-session-id: ${mcp_session_id}\" \\
  -d '{\"jsonrpc\":\"2.0\",\"method\":\"notifications/initialized\"}'"

# tools/list request
show "curl -s -X POST http://localhost:8885/messages \\
  -H \"Content-Type: application/json\" \\
  -H \"Accept: application/json, text/event-stream\" \\
  -H \"mcp-protocol-version: 2025-11-25\" \\
  -H \"mcp-session-id: ${mcp_session_id}\" \\
  -d '{\"jsonrpc\":\"2.0\",\"id\":2,\"method\":\"tools/list\",\"params\":{}}'"

# call list_kubeconfig_contexts tool
# run "curl -s -X POST http://localhost:8885/messages \\
#   -H \"Content-Type: application/json\" \\
#   -H \"Accept: application/json, text/event-stream\" \\
#   -H \"mcp-protocol-version: 2025-11-25\" \\
#   -H \"mcp-session-id: ${mcp_session_id}\" \\
#   -d '{\"jsonrpc\":\"2.0\",\"id\":3,\"method\":\"tools/call\",\"params\":{\"name\":\"list_kubeconfig_contexts\",\"arguments\":{}}}'"
