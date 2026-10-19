#!/usr/bin/env python3
"""Print a fresh `Bearer <token>` for the Atlassian MCP server.

Reads/writes ~/.omp/agent/atlassian-mcp-token.json, refreshing the access token
when it is within 5 minutes of expiry. Referenced from mcp.json as a `!command`
header value, so OMP calls it once per process before connecting.
"""

import json
import os
import time
import urllib.parse
import urllib.request

STORE = os.path.expanduser("~/.omp/agent/atlassian-mcp-token.json")

with open(STORE) as fh:
    tok = json.load(fh)

if tok["expires_at"] - time.time() < 300:
    body = urllib.parse.urlencode(
        {
            "grant_type": "refresh_token",
            "refresh_token": tok["refresh_token"],
            "client_id": tok["client_id"],
        }
    ).encode()
    req = urllib.request.Request(
        tok["token_url"],
        data=body,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        fresh = json.load(resp)
    tok["access_token"] = fresh["access_token"]
    tok["refresh_token"] = fresh.get("refresh_token", tok["refresh_token"])
    tok["expires_at"] = int(time.time()) + fresh["expires_in"]
    tmp = STORE + ".tmp"
    with open(os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600), "w") as fh:
        json.dump(tok, fh, indent=2)
    os.replace(tmp, STORE)

print("Bearer " + tok["access_token"])
