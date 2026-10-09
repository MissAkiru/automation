# Daily Briefing + 3-Hour World News

Two n8n workflows:

1. **`n8n-3h-news.json`** — every 3 hours, pulls 15 world headlines
   (GNews free tier) into the **News Cache** sheet tab. This is the cache;
   it costs 8 GNews calls/day.
2. **`n8n-daily-brief.json`** — every day at **07:00 Asia/Dubai**, reads the
   last 24h of news + the Daily Log tab, and an OpenAI step writes the brief
   in the exact format in `BRIEFING-FORMAT.md`, emails it to
   `BRIEF_TO_EMAIL`, and archives a copy in the **Briefings** tab.

The brief answers your five questions, in order:
1. tasks for the day
2. what was done yesterday
3. what the AI is doing today
4. current world news
5. what needs our attention

## Setup (15 min)

1. Import both JSONs (n8n → Workflows → Import from File).
2. Env vars (KEYS.md #K1, #K2, #K8): `GNEWS_API_KEY`, `SHEETS_DOC_ID`,
   `BRIEF_TO_EMAIL`; credentials: **OpenAI API** (the n8n OpenAI credential
   type, paste K1), **Google OAuth2** (K8 — the account that owns the sheet).
3. Make sure the 5 sheet tabs exist (exact headers in KEYS.md).
4. Activate both workflows.

## The Daily Log is the memory of the house

The brief is only as good as the log. Convention (human and agents alike):

- Each morning: add today's rows — `kind=task` (yours, `owner=me`),
  `kind=ai-plan` (agent work, `owner=agent`), `status=open`.
- Each session end (yours or an agent's): append what actually happened —
  one row per thing, `kind=done`, `owner=me|agent`.

### Seed rows for today (paste into the Daily Log tab, 2026-09-24)

```
2026-09-24 | task    | GitHub: review 17 public repos — delete/privatize SEO-spam ones | me    | open
2026-09-24 | task    | Deploy founder site (Netlify drop + DNS per DEPLOY.md)          | me    | open
2026-09-24 | task    | Get keys K1–K9 (KEYS.md), create 5 sheet tabs                   | me    | open
2026-09-24 | task    | Colosseum go/no-go (hackathon runs to Nov 2)                    | me    | open
2026-09-24 | ai-plan | Briefing engine live — first brief 07:00 today                  | agent | open
2026-09-24 | ai-plan | Daily content engine live — first posts 06:00 (LinkedIn + X)    | agent | open
2026-09-23 | done    | Overnight build: founder site, repo, Cart402+loop, dashboard, consulting playbook, stack docs | agent | done
2026-09-23 | done    | Security scan: akirusystems.com healthy (SSL 76d, DMARC gap)   | agent | done
2026-09-23 | done    | Founding risk flagged: 17 public repos incl. SEO-spam           | agent | done
```

## Operations

- **Keep News Cache small:** the 3h job appends ~120 rows/day. Weekly:
  delete rows older than 7 days (or let the tab grow for a month, then
  trim). The brief only reads the last 24h.
- **Brief quality:** the format is pinned in `BRIEFING-FORMAT.md`. If the
  brief drifts, edit the system message in the OpenAI node — that file is
  the source of truth for what goes in it.
- **Timezone:** both schedules run in Asia/Dubai (workflow setting).
- **Failed day:** if a run fails in n8n, open it and re-execute — the sheet
  row is the record, the email is the delivery.
