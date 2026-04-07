# Demo — macOS EDR Prototype

## Scenario 1 — Process Detection

Start a new process:

```bash
python3 -m http.server 9999
```

### Detected Event

```json
{"timestamp":"2026-04-07T19:55:50","type":"process","event":"new_process","data":"/usr/bin/python3"}
```

---

## Scenario 2 — Port Monitoring

New listening port detected:

```json
{"timestamp":"2026-04-07T19:51:28","type":"port","event":"port_change","data":"Python *:9999"}
```

---

## Scenario 3 — File Monitoring

File created or modified:

```bash
touch test.txt
```

### Detected Event

```json
{"timestamp":"2026-04-07T20:00:10","type":"file","event":"file_change","data":"test.txt"}
```

---

## Notes

- Events are logged in `logs/edr.log`
- Monitoring is executed via launchd persistence
- Designed for lightweight endpoint visibility
