# LTX

Generate and edit video and audio with LTX models from Cursor.

This repository is the Cursor Directory listing for the hosted LTX MCP server
at `https://app.ltx.io/mcp`. It contains install configuration only. No code
runs on your machine. Generations run on LTX and are billed to the LTX
organization you choose when you connect.

## Install

1. Install **LTX** from [Cursor Directory](https://cursor.directory).
2. Enable the **ltx** MCP server and connect it.
3. Sign in to your LTX account in the browser and pick the organization to bill.

Cursor discovers sign-in from the server. This repo has no API key to paste.

## What you can ask for

- Create a video from an image, a text prompt, or an audio track
- Edit a video: reframe, retake a section, extend, convert to HDR, remove objects, deblur, restore compression, relight day to night, add sound effects
- Compose a video from several stills, make a cinemagraph, or make a talking avatar
- Edit speech: extend audio, retake a spoken segment, separate voice from background, harmonise accents

The agent waits for each job and posts the result link when it is done.

## Billing and accounts

Ask the agent which LTX account is connected, or to switch organization or
account. Switching opens a browser link. Disconnect from Cursor's MCP settings
to revoke the session.

## Local files

The server cannot read your disk. For a local image, the agent uploads it with
a one-time ticket. For local audio or video, the agent gives you a link to a
drop zone.

## License

MIT. See `LICENSE`. This covers the configuration in this repository, not the
LTX service or its models.
