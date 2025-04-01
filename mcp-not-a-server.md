# Anthropic’s “MCP server” isn’t really a server

Anthropic describes part of their Model Context Protocol (MCP) system as a “server”.

But if you dig into it, there’s no TCP listener, no open port, no HTTP endpoint.

It’s just a CLI tool that reads JSON-RPC messages from stdin and writes to stdout. When you run `mcp install`, nothing is launched — it simply registers your Python script to be called later as a subprocess by the Claude desktop app.

I wasted 30 minutes trying to figure out what port it was listening on.

Please stop calling this a “server”. It's not. It's a command-line handler at best.

---

> “So I assume this MCP server is like a local daemon that handles JSON-RPC requests over HTTP?”  
> — https://news.ycombinator.com/item?id=42237424

Nope. It isn’t.
