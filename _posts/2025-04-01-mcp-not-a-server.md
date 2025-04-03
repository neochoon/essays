---
layout: post
title: "Anthropic’s MCP server isn’t really a server"
author: ChoonSik C.
---

When developers hear terms like “server”, “host”, and “client”, there's a certain architecture they assume:

- A **host** is simply the system that runs and connects all the components — server, client, and model alike.
- A **client** initiates the connection and sends requests.
- A **server** is a process that runs persistently, waiting for connections — not something you invoke only when needed.  
  It might expose a public API, or it might serve over a Unix domain socket or other IPC mechanisms, but the key idea is that it’s always **listening**.

Anthropic’s Model Context Protocol (MCP) uses familiar terms — "host", "client", and "server" — but defines them in its own way:

- **MCP Hosts** are programs like the Claude desktop app, IDEs, or AI tools that want to access data or functionality via MCP.
- **MCP Clients** are protocol clients that maintain 1:1 connections with individual servers and make requests on behalf of the model.
- **MCP Servers** are lightweight programs — often simple Python, TypeScript scripts — that expose specific capabilities (tools, resources, prompts) via the standardized Model Context Protocol.

In this setup:
- The **Claude desktop app** acts as the **host**.
- The **LLM running inside Claude** is the **client**, issuing tool/resource/prompt requests via the protocol.
- Your local application, written using `FastMCP`, is the so-called **“server”**.

But here's the catch: that “server” doesn’t listen for connections, expose an API, or run in the background. It just sits idle until Claude launches it as a subprocess and feeds it JSON-RPC messages via `stdin`.

...


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
