# eBike System â€“ Complete Modular Project

This repository contains all modules to design, build, and program a full electric bicycle: hardware (schematics/placeholders), firmware, software, docs, and manufacturing guides.

See `docs/system-architecture.md` to understand how everything fits.

## Quick Start
1. Read `docs/system-architecture.md` and choose your specs (voltage, power, legal class).
2. Build firmware in `firmware/controller_fw` with PlatformIO (ESP32 example).
3. Populate hardware schematics in KiCad files under `hardware/*`.
4. Use `scripts/commit_push.ps1` to commit & push to GitHub.

---

## Repo Structure
./
â”œâ”€â”€ docs/
â”œâ”€â”€ hardware/
â”œâ”€â”€ firmware/
â”œâ”€â”€ software/
â”œâ”€â”€ manufacturing/
â””â”€â”€ scripts/

sql
Copy
Edit

Each folder contains its own README or files described below.

Enjoy building! ðŸš²âš¡