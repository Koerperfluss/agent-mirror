import unittest
from unittest.mock import patch, MagicMock
import json
import sys
import os

# Import-Pfad: Tests werden aus dem Repo-Root gestartet
# (python3 -m unittest discover -s tests); alternativ via QFS_SCRIPTS_DIR.
SCRIPTS_DIR = os.environ.get("QFS_SCRIPTS_DIR", "scripts")
sys.path.append(SCRIPTS_DIR)

import pi_benchmark
import pi_re_client

class TestPiTools(unittest.TestCase):

    def test_sse_parsing_benchmark(self):
        """Testet das Parsen von SSE-Chunks im Benchmark-Tool."""
        mock_response = [
            b'data: {"choices": [{"delta": {"content": "Hallo"}}], "usage": null}\n',
            b'data: {"choices": [], "usage": {"prompt_tokens": 10, "completion_tokens": 5}}\n',
            b'data: [DONE]\n'
        ]

        with patch('urllib.request.urlopen') as mock_url:
            mock_url.return_value.__enter__.return_value = mock_response
            res = pi_benchmark.run_benchmark("http://test:8080", "Test", 10)

            self.assertIsNotNone(res)
            self.assertEqual(res["prompt_tokens"], 10)
            self.assertEqual(res["completion_tokens"], 5)
            self.assertGreater(res["ttft"], 0)

    def test_tokenrate_calculation(self):
        """Testet die Berechnung der Tokens pro Sekunde."""
        # comp_tokens / (total_time - ttft)
        # 100 tokens / (2.0s - 1.0s) = 100 tps
        res = {
            "ttft": 1.0,
            "total_time": 2.0,
            "completion_tokens": 100,
            "prompt_tokens": 50,
            "tps": 100.0,
            "pp_rate": 50.0
        }
        self.assertEqual(res["tps"], 100.0)

    def test_missing_usage_data(self):
        """Testet das Verhalten bei fehlenden Usage-Daten."""
        mock_response = [
            b'data: {"choices": [{"delta": {"content": "Hallo"}}] }\n',
            b'data: [DONE]\n'
        ]
        with patch('urllib.request.urlopen') as mock_url:
            mock_url.return_value.__enter__.return_value = mock_response
            res = pi_benchmark.run_benchmark("http://test:8080", "Test", 10)
            self.assertEqual(res["prompt_tokens"], 0)
            self.assertEqual(res["completion_tokens"], 0)

    def test_re_client_prompt_building(self):
        """Testet ob der RE-Client den Prompt korrekt zusammensetzt."""
        with patch('argparse.ArgumentParser.parse_args') as mock_args:
            mock_args.return_value = MagicMock(
                task="hid", input="-", question="Was ist das?", host="http://localhost:8080", output=None
            )
            with patch('sys.stdin.read', return_value="01 02 03"):
                self.assertIn("hid", pi_re_client.PROFILES)
                self.assertTrue(len(pi_re_client.SYSTEM_PROMPT) > 0)

    def test_arg_parsing(self):
        """Testet das Argument-Parsing (einfacher Check)."""
        with patch('sys.argv', ['script.py', '--host', 'http://spark:9090', '--suite', 'traktor']):
            args = pi_benchmark.get_args()
            self.assertEqual(args.host, 'http://spark:9090')
            self.assertEqual(args.suite, 'traktor')


class TestStreamParsingFixes(unittest.TestCase):
    """Regression-Tests für Code-Review-Findings (Stand 2026-10-25)."""

    def test_re_stream_empty_choices_no_crash(self):
        """Finding 1: Final-Chunk mit leerer choices-Liste darf den Stream nicht crashen."""
        lines = [
            b'data: {"choices": [{"delta": {"content": "Analyse:"}}]}\n',
            b'data: {"choices": [], "usage": {"prompt_tokens": 5, "completion_tokens": 3}}\n',
            b'data: [DONE]\n',
        ]
        content, reasoning = pi_re_client.parse_re_stream(lines)
        self.assertEqual(content, "Analyse:")
        self.assertEqual(reasoning, "")

    def test_re_stream_reasoning_capture(self):
        """Reasoning-Content wird gesammelt, ohne in content zu landen."""
        lines = [
            b'data: {"choices": [{"delta": {"reasoning_content": "denke..."}}]}\n',
            b'data: {"choices": [{"delta": {"content": "Antwort"}}]}\n',
            b'data: [DONE]\n',
        ]
        content, reasoning = pi_re_client.parse_re_stream(lines)
        self.assertEqual(content, "Antwort")
        self.assertEqual(reasoning, "denke...")

    def test_benchmark_data_prefix_without_space(self):
        """Finding 4: 'data:' ohne Leerzeichen wird trotzdem geparst."""
        mock_response = [
            b'data:{"choices": [{"delta": {"content": "Hi"}}]}\n',
            b'data: [DONE]\n',
        ]
        with patch('urllib.request.urlopen') as mock_url:
            mock_url.return_value.__enter__.return_value = mock_response
            res = pi_benchmark.run_benchmark("http://test:8080", "T", 5)
            self.assertIsNotNone(res)
            self.assertGreater(res["ttft"], 0)

    def test_benchmark_flags_missing_usage(self):
        """Finding 5: Läufe ohne usage werden als usage_missing gekennzeichnet."""
        mock_response = [
            b'data: {"choices": [{"delta": {"content": "Hallo"}}]}\n',
            b'data: [DONE]\n',
        ]
        with patch('urllib.request.urlopen') as mock_url:
            mock_url.return_value.__enter__.return_value = mock_response
            res = pi_benchmark.run_benchmark("http://test:8080", "T", 5)
            self.assertTrue(res["usage_missing"])

if __name__ == '__main__':
    unittest.main()
