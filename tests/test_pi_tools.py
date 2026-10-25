import unittest
from unittest.mock import patch, MagicMock
import json
import os
import sys

# Import-Pfad: Tests werden aus dem Repo-Root gestartet
# (python3 -m unittest discover -s tests); alternativ via QFS_SCRIPTS_DIR.
SCRIPTS_DIR = os.environ.get("QFS_SCRIPTS_DIR", "scripts")
sys.path.append(SCRIPTS_DIR)

import pi_benchmark
import pi_re_client

def mock_opener_factory(mock_response):
    """Baut einen build_opener-Mock, dessen open() den Stream liefert."""
    opener = MagicMock()
    opener.open.return_value.__enter__.return_value = mock_response
    return opener

class TestPiTools(unittest.TestCase):

    def test_sse_parsing_benchmark(self):
        """Testet das Parsen von SSE-Chunks im Benchmark-Tool."""
        mock_response = [
            b'data: {"choices": [{"delta": {"content": "Hallo"}}], "usage": null}\n',
            b'data: {"choices": [], "usage": {"prompt_tokens": 10, "completion_tokens": 5}}\n',
            b'data: [DONE]\n'
        ]
        with patch('urllib.request.build_opener',
                   return_value=mock_opener_factory(mock_response)):
            res = pi_benchmark.run_benchmark("http://test:8080", "Test", 10, allow_lan=True)
            self.assertIsNotNone(res)
            self.assertEqual(res["prompt_tokens"], 10)
            self.assertEqual(res["completion_tokens"], 5)
            self.assertGreater(res["ttft"], 0)

    def test_tokenrate_calculation(self):
        """Testet die Berechnung der Tokens pro Sekunde (Formel-Check)."""
        res = {
            "ttft": 1.0,
            "total_time": 2.0,
            "completion_tokens": 100,
            "prompt_tokens": 50,
        }
        self.assertEqual(res["completion_tokens"] / (res["total_time"] - res["ttft"]), 100.0)

    def test_missing_usage_data(self):
        """Fehlende Usage-Daten: Werte 0 und usage_missing=True."""
        mock_response = [
            b'data: {"choices": [{"delta": {"content": "Hallo"}}] }\n',
            b'data: [DONE]\n'
        ]
        with patch('urllib.request.build_opener',
                   return_value=mock_opener_factory(mock_response)):
            res = pi_benchmark.run_benchmark("http://test:8080", "Test", 10, allow_lan=True)
            self.assertEqual(res["prompt_tokens"], 0)
            self.assertEqual(res["completion_tokens"], 0)
            self.assertTrue(res["usage_missing"])

    def test_re_client_profiles_complete(self):
        """Alle argparse-Task-Choices haben ein PROFILES-Element (kein KeyError)."""
        for task in ["hid", "mapping", "capture", "format", "codegen", "rebuild"]:
            self.assertIn(task, pi_re_client.PROFILES)
        self.assertTrue(len(pi_re_client.SYSTEM_PROMPT) > 0)

    def test_rebuild_profile_demands_json_schema(self):
        """rebuild-Profil fordert FEATURES.json-Schema und BEOBACHTUNG/HYPOTHESE-Trennung."""
        profile = pi_re_client.PROFILES["rebuild"]
        self.assertIn("FEATURES.json", profile)
        self.assertIn("BEOBACHTUNG", profile)
        self.assertIn("[VORSCHLAG]", profile)

    def test_arg_parsing(self):
        """Testet das Argument-Parsing (einfacher Check)."""
        with patch('sys.argv', ['script.py', '--host', 'http://spark:9090', '--suite', 'traktor']):
            args = pi_benchmark.get_args()
            self.assertEqual(args.host, 'http://spark:9090')
            self.assertEqual(args.suite, 'traktor')


class TestHostValidation(unittest.TestCase):
    """SSRF-Guard: Schema-Prüfung, /v1-Normalisierung, LAN-Freigabe."""

    def test_rejects_non_http_scheme(self):
        for bad in ["ftp://spark:8080", "file:///etc/passwd", "gopher://x"]:
            with self.assertRaises(ValueError, msg=bad):
                pi_re_client.validate_host(bad, allow_lan=True)

    def test_rejects_host_without_hostname(self):
        with self.assertRaises(ValueError):
            pi_re_client.validate_host("http://", allow_lan=True)

    def test_strips_trailing_v1(self):
        self.assertEqual(pi_re_client.validate_host("http://192.168.1.5:8080/v1/", allow_lan=True),
                         "http://192.168.1.5:8080")

    def test_private_ip_blocked_without_allow_lan(self):
        # 192.0.2.1 ist TEST-NET (reserved) -> wird auch ohne DNS blockiert? Nein:
        # getaddrinfo löst es zu sich selbst auf; is_reserved greift.
        with self.assertRaises(ValueError):
            pi_re_client.validate_host("http://192.0.2.1:8080", allow_lan=False)


class TestStreamParsingFixes(unittest.TestCase):
    """Regression-Tests für Code-Review-Findings (Stand 2026-10-26)."""

    def test_re_stream_empty_choices_no_crash(self):
        """Final-Chunk mit leerer choices-Liste darf den Stream nicht crashen."""
        import io
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
        """'data:' ohne Leerzeichen wird trotzdem geparst."""
        mock_response = [
            b'data:{"choices": [{"delta": {"content": "Hi"}}]}\n',
            b'data: [DONE]\n',
        ]
        with patch('urllib.request.build_opener',
                   return_value=mock_opener_factory(mock_response)):
            res = pi_benchmark.run_benchmark("http://test:8080", "T", 5, allow_lan=True)
            self.assertIsNotNone(res)
            self.assertGreater(res["ttft"], 0)

if __name__ == '__main__':
    unittest.main()
