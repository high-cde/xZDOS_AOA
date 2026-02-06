import os
import glob
import re
from datetime import datetime

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
LOG_DIR = os.path.join(ROOT_DIR, "logs")

def parse_logs():
    pattern = os.path.join(LOG_DIR, "sentinel_*.log")
    files = sorted(glob.glob(pattern))
    summary = {
        "total_cycles": 0,
        "status_counts": {},
        "last_cycle": None,
    }

    status_re = re.compile(r"Ciclo SENTINEL completato — Stato: (\w+)")
    time_re = re.compile(r"^\[(\d{2}:\d{2}:\d{2})\]")

    for f in files:
        with open(f, "r", encoding="utf-8", errors="ignore") as fh:
            last_status = None
            last_time = None
            for line in fh:
                m_s = status_re.search(line)
                if m_s:
                    last_status = m_s.group(1)
                m_t = time_re.match(line)
                if m_t:
                    last_time = m_t.group(1)
            if last_status:
                summary["total_cycles"] += 1
                summary["status_counts"][last_status] = summary["status_counts"].get(last_status, 0) + 1
                summary["last_cycle"] = {
                    "file": os.path.basename(f),
                    "status": last_status,
                    "time": last_time,
                }

    return summary

if __name__ == "__main__":
    s = parse_logs()
    print("=== SENTINEL ANALYZER ===")
    print(f"Total cycles: {s['total_cycles']}")
    print("Status counts:")
    for k, v in s["status_counts"].items():
        print(f"  {k}: {v}")
    if s["last_cycle"]:
        print("Last cycle:")
        print(f"  File: {s['last_cycle']['file']}")
        print(f"  Status: {s['last_cycle']['status']}")
        print(f"  Time: {s['last_cycle']['time']}")
