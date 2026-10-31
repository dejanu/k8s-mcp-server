## MCP What's the health of my Kubernetes cluster?

Assessment-only,  no mutations to the cluster:

```
✅ get_cluster_info - Version, node count, namespace count
✅ check_node_health - Node conditions, capacity, allocatable resources
✅ check_pod_health - Pod status across namespaces, problem detection
✅ get_resource_usage - CPU/memory usage (requires metrics-server)
✅ diagnose_cluster - Comprehensive health check with issue detection
✅ get_namespace_summary - Resource counts per namespace
[WIP] check_networking - Istio networking overview
```

## Start and test the MCP server

* Server implementations:

    `k8s_mcp_server_local.py` - STDIO transport, uses the MCP SDK’s lower-level Server API. Clients SHOULD support stdio whenever possible](https://modelcontextprotocol.io/specification/2025-11-25/basic/transports#streamable-http)
    
    `k8s_mcp_server_http.py` — uses FastMCP’s higher-level API

* MCP inspector

```bash
# setup a kubeconfig 
export KUBECONFIG=~/.kube/config

# install inspector
npm install -g @modelcontextprotocol/inspector

# run the server STDIO mode
mcp-inspector .venv/bin/python k8s_mcp_server_local.py

# run the server HTTP mode
uv run k8s_mcp_server_http.py 
npx @modelcontextprotocol/inspector --transport http http://localhost:8885/messages
```

### Prompts 

* Prompts

```
Is the cluster healthy?
Are all nodes ready? 
Show me any pods that are not running  
Diagnose the cluster and explain what needs attention

Are there any nodes under resource pressure?
Show resource usage and identify which nodes are overloaded
Which pods are consuming the most CPU and memory?
Is there enough capacity to schedule more workloads?

Give me a summary of all namespaces

Give me a full cluster assessment — nodes, pods, resource usage, and any issues
Compare resource usage across nodes , is the workload balanced?

Diagnose the cluster and explain what needs attention
What's the overall state of the cluster and what should I fix first?
```

* Claude Code integration via `.mcp.json`

```json

{
  "mcpServers": {
    "kubernetes": {
      "command": "/Users/alexandru.dejanu/tools/k8s-mcp-server/venv/bin/python",
      "args": [
        "/Users/alexandru.dejanu/tools/k8s-mcp-server/k8s_mcp_server_local.py"
      ],
      "env": {
        "KUBECONFIG": "/abs/path/to/kubeconfig"
      }
    }
  }
}
```


```json
{
  "mcpServers": {
    "kubernetes": {
      "type": "http",
      "url": "http://localhost:8000/messages"
    }
  }
}
```