#!/bin/bash
# LokiCanvas Tests — CLT ohne Xcode braucht den TestingMacros-Plugin-Pfad explizit.
set -euo pipefail
cd "$(dirname "$0")"
exec swift test \
  -Xswiftc -plugin-path \
  -Xswiftc /Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing \
  "$@"
