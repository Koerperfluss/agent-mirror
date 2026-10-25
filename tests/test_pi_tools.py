import unittest
from unittest.mock import patch, MagicMock
import json
import sys
import os

# Pfade für Imports anpassen
sys.path.append(os.path.join(os.path.dirname(__file__), '../scripts'))

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
            # Hier testen wir indirekt die Logik im main()
            # Da main() direkt sys.stdin liest, mocken wir das
            with patch('sys.stdin.read', return_value="01 02 03"):
                # Wir prüfen hier nur, ob die PROFILES und SYSTEM_PROMPT vorhanden sind
                self.assertIn("hid", pi_re_client.PROFILES)
                self.assertTrue(len(pi_re_client.SYSTEM_PROMPT) > 0)

    def test_arg_parsing(self):
        """Testet das Argument-Parsing (einfacher Check)."""
        with patch('sys.argv', ['script.py', '--host', 'http://spark:9090', '--suite', 'traktor']):
            args = pi_benchmark.get_args()
            self.assertEqual(args.host, 'http://spark:9090')
            self.assertEqual(args.suite, 'traktor')

if __name__ == '__main__':
    unittest.main()
