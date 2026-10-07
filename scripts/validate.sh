#!/usr/bin/env bash
# Fails when the Cursor Directory config drifts from the production LTX MCP contract.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

fail() { echo "validate: $*" >&2; exit 1; }

need() { [[ -f "$1" ]] || fail "missing $1"; }

need .mcp.json
need mcp.json
need .cursor-plugin/plugin.json
need assets/logo.png
need README.md
need LICENSE

python3 - <<'PY'
import json, pathlib, sys
root = pathlib.Path(".")

def load(name):
    try:
        return json.loads(pathlib.Path(name).read_text())
    except json.JSONDecodeError as exc:
        sys.exit(f"validate: {name} is not JSON: {exc}")

dotted = load(".mcp.json")
plain = load("mcp.json")
if dotted != plain:
    sys.exit("validate: .mcp.json and mcp.json differ")

servers = dotted.get("mcpServers")
if not isinstance(servers, dict) or set(servers) != {"ltx"}:
    sys.exit("validate: mcpServers must be exactly {ltx}")
entry = servers["ltx"]
if entry != {"url": "https://app.ltx.io/mcp"}:
    sys.exit(f"validate: ltx entry must be only the production url, got {entry!r}")

manifest = load(".cursor-plugin/plugin.json")
expected = {
    "name": "ltx",
    "displayName": "LTX",
    "version": "1.0.0",
    "description": "Generate and edit video and audio with LTX models from Cursor.",
    "author": {"name": "Lightricks"},
    "homepage": "https://ltx.io",
    "repository": "https://github.com/Lightricks/ltx-cursor-plugin",
    "license": "MIT",
    "keywords": ["ltx", "video", "video-generation", "audio", "ai", "mcp"],
    "logo": "assets/logo.png",
    "mcpServers": "./mcp.json",
}
if manifest != expected:
    sys.exit(f"validate: plugin.json mismatch:\n{json.dumps(manifest, indent=2)}")

blob = pathlib.Path(".mcp.json").read_text() + pathlib.Path("mcp.json").read_text()
for banned in ("localhost", "127.0.0.1", "Authorization", "api_key", "apiKey", "secret", "token", "${"):
    if banned in blob:
        sys.exit(f"validate: banned string {banned!r} in mcp config")
PY

# PNG magic bytes
python3 - <<'PY'
from pathlib import Path
data = Path("assets/logo.png").read_bytes()
if len(data) < 32 or data[:8] != b"\x89PNG\r\n\x1a\n":
    raise SystemExit("validate: assets/logo.png is not a PNG")
PY

grep -q "https://app.ltx.io/mcp" README.md || fail "README does not name the MCP url"
grep -q "MIT" LICENSE || fail "LICENSE is not the existing MIT file"

echo "validate: ok"
