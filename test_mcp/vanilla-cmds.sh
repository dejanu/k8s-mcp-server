# smoke test
curl -s http://localhost:8885/health

# initialize request — mcp-session-id comes back in the response headers
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

mcp_session_id=INSERTSESSIONIDHERE

# initialized notification
curl -s -X POST http://localhost:8885/messages \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "mcp-protocol-version: 2025-11-25" \
  -H "mcp-session-id: ${mcp_session_id}" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

# tools/list request
curl -s -X POST http://localhost:8885/messages \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "mcp-protocol-version: 2025-11-25" \
  -H "mcp-session-id: ${mcp_session_id}" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'

# call get_cluster_info tool
curl -s -X POST http://localhost:8885/messages \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "mcp-protocol-version: 2025-11-25" \
  -H "mcp-session-id: ${mcp_session_id}" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_cluster_info","arguments":{}}}'
