## MCP What's the health of my Kubernetes cluster?

[What is MCP more exactly? a quick overview.](https://dejanualex.medium.com/claude-mcp-from-zero-to-hero-a5bca458d74c)

k8s-mcp **assessment-only**, no mutations to the cluster, available tools:

```
✅ list_kubeconfig_contexts - List kubeconfig contexts and the active one
✅ get_kubeconfig_context - Show the active cluster context for the session
✅ set_kubeconfig_context - Switch the active cluster context for the session
✅ get_cluster_info - API version and nodes (like kubectl get nodes -o wide)
✅ check_node_health - Node conditions, capacity, allocatable resources
✅ check_pod_health - Pod status across namespaces, problem detection
✅ list_pod_images - Container images for a pod or all pods in a namespace
✅ get_resource_usage - CPU/memory usage (requires metrics-server)
✅ diagnose_cluster - Comprehensive health check with issue detection
✅ get_namespace_summary - Resource counts per namespace
✅ check_networking - Istio control plane, sidecars, config, endpoints, NetworkPolicies
✅ check_argo_apps - Argo CD Application sync and health status
```

## Start and test the MCP server

* Server implementations:

    `k8s_mcp_server_local.py` - STDIO transport, uses the MCP SDK’s lower-level Server API. Clients [SHOULD support stdio whenever possible](https://modelcontextprotocol.io/specification/2025-11-25/basic/transports#streamable-http)
    
    `k8s_mcp_server_http.py` — uses FastMCP’s higher-level API

* [MCP inspector](https://modelcontextprotocol.io/docs/2026-07-28/tools/inspector)

```bash
# setup a kubeconfig 
export KUBECONFIG=~/.kube/config

# install inspector
npm install -g @modelcontextprotocol/inspector

# run the server STDIO mode directly (don't forget about the client ;) 
uv run python k8s_mcp_server_local.py

# launch the STDIO server through MCP Inspector
mcp-inspector uv run python k8s_mcp_server_local.py

# run the server HTTP mode
uv run k8s_mcp_server_http.py 
npx @modelcontextprotocol/inspector --transport http http://localhost:8885/messages 

# run the server HTTP mode as container
docker run --rm -p 8885:8885 \
    -v absolute-path-toyour-kubeconfig:/kube/config:ro \
    -e KUBECONFIG=/kube/config \
    dejanualex/k8s-mcp-server:0.1.0
```

### Prompts 

* Prompt examples for the Kubernetes cluster health assessment:

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