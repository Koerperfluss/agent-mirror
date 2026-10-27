#!/bin/bash
# TraktorClone Tests — CLT ohne Xcode braucht den TestingMacros-Plugin-Pfad explizit
# (bekanntes CLT-Race: "plugin for module 'TestingMacros' not found").
set -euo pipefail
cd "$(dirname "$0")"
exec swift test \
  -Xswiftc -plugin-path \
  -Xswiftc /Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing \
  "$@"
