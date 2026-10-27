#!/usr/bin/env python3
"""Kleiner stateful Mock-Server für einen autonomen Agenten-Testlauf."""
import argparse
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ACTIONS = [
    {"tool": "write_file", "arguments": {
        "path": "tests/test_generated.py",
        "content": ("import unittest\n"
                    "class T(unittest.TestCase):\n"
                    "    def test_ok(self):\n"
                    "        self.assertEqual(2 + 2, 4)\n")}},
    {"tool": "run_tests", "arguments": {}},
    {"tool": "finish", "arguments": {"summary": "Autonomer Zyklus fertig"}},
]
STATE = {"calls": 0}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_args):
        pass

    def do_POST(self):
        if not self.path.rstrip("/").endswith("/v1/chat/completions"):
            self.send_error(404)
            return
        length = int(self.headers.get("Content-Length", "0"))
        self.rfile.read(length)
        index = STATE["calls"]
        STATE["calls"] += 1
        action = ACTIONS[min(index, len(ACTIONS) - 1)]
        body = json.dumps({
            "model": "mock-qwen",
            "choices": [{"message": {"role": "assistant",
                                     "content": json.dumps(action)},
                         "finish_reason": "stop"}],
            "usage": {"prompt_tokens": 10, "completion_tokens": 10},
        }).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=18085)
    args = parser.parse_args()
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    print(f"Mock-Agent-Server auf http://127.0.0.1:{args.port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
