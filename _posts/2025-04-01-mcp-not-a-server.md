---
layout: default
title: "Anthropic’s MCP server isn’t really a server"
date: 2024-04-01
---

When developers hear terms like “server”, “host”, and “client”, there's a certain architecture they assume:

- A **server** is a process that runs persistently, waiting for connections — not something you invoke only when needed.  
  It might expose a public API, or it might serve over a Unix domain socket or other IPC mechanisms, but the key idea is that it’s always **listening**.
- A **client** initiates the connection and sends requests.
- A **host** provides the environment that bridges and runs the components.

Anthropic’s Model Context Protocol (MCP) borrows this vocabulary, but maps it quite differently:

- The **Claude desktop app** is the **host**.
- The **LLM running inside Claude** is the **client** — it's the entity issuing tool/resource/prompt requests.
- Your local application, implemented using `FastMCP`, is the so-called **“server”**.

But here’s the catch: that “server” doesn’t listen on a port.  
It doesn’t expose an API.  
It doesn’t wait passively for connections of any kind.

It waits on stdin for JSON-RPC messages and replies through stdout.
It doesn't start automatically or listen in the background.

When you run mcp install your_server.py, it doesn't launch the script.
It only registers the path so that Claude can run it later as a subprocess — but only when the LLM actually needs it.

When you run mcp dev your_server.py, it starts a proxy server and the MCP Inspector — but it still doesn’t launch your script.

I wasted some time trying to figure out what port it was listening on.


**Please stop calling this a “server”. It's not. It's a command-line handler at best.**

> “So I assume this MCP server is like a local daemon that handles JSON-RPC requests over HTTP?”  
> — https://news.ycombinator.com/item?id=42237424

Nope. It isn’t.
