# Content Studio — daily posts, videos, affiliate

What runs here:

| Asset | File | Cadence |
|---|---|---|
| Daily LinkedIn + X post (engaging, on-brand, news-hooked) | `n8n-daily-content.json` | 06:00 Dubai, daily |
| YouTube upload (review-before-publish) | `n8n-youtube-upload.json` | on demand |
| Video production pipeline (script → voice → slides → render) | `VIDEO-PIPELINE.md` + `render-video.sh` | 1 long-form/week + 2–3 clips |
| Affiliate strategy (accounts, placement, disclosure) | `AFFILIATE.md` | ongoing |

## Setup (20 min)

1. Import both JSONs into n8n.
2. Reuse credentials from the blog autopost: LinkedIn header auth, X header
   auth, Google OAuth2. Add the **OpenAI** credential (K1).
3. Env vars: `SHEETS_DOC_ID` (already set), `GNEWS_API_KEY` (for the hook —
   actually read from the News Cache sheet, so the 3h job must be active).
4. Create the **Content Log** tab if not already (headers in KEYS.md).
5. Activate `n8n-daily-content.json`. Leave the YouTube one **inactive** —
   it's a form trigger you run by hand.

## The daily post — what it is and is not

- **Is:** one LinkedIn post (120–180 words) + one X post (≤270 chars),
  written by the model in the Miss Akiru voice (the WRITING-GUIDE rules are
  baked into the prompt), hooked to a real news item from the last 24h when
  one fits, with the akirusystems.com link on Tue/Thu only (link-spam is
  how accounts get shadow-banned).
- **Is not:** a spam cannon. One per platform per day, every post is
  readable standing alone, and nothing is auto-deleted or auto-boosted.
- **Review mode (first 2 weeks):** the workflow is the same, but set it to
  draft — in n8n, pause the LinkedIn/X nodes and check the sheet's Content
  Log tab before letting them run. Two weeks of clean posts, then unpause.

## YouTube

1. Produce the video per `VIDEO-PIPELINE.md` (script → voice → slides →
   `render-video.sh`).
2. Run the `n8n-youtube-upload.json` form: pick the file, title, description
   (use the description template in VIDEO-PIPELINE.md — it carries the
   affiliate links + disclosure + site link).
3. Uploads land **unlisted** — you flip to public in YouTube Studio after a
   final look. The unlisted step is the safety valve; keep it.

## Affiliate

Read `AFFILIATE.md` before connecting any account. The short version:
only programs for tools we actually use, disclosure on every placement
(FTC + platform rules), links live in video descriptions, the
`/affiliates` page, and blog posts — never in a casual DM.

## The weekly rhythm (suggested)

| Day | Human | Agent |
|---|---|---|
| Mon | 10 min: review yesterday's Content Log, note one topic | daily posts (06:00) |
| Tue | record voiceover for the week's video (15 min) | video script ready (from the video pipeline) |
| Wed | — | daily posts; video render + unlisted upload |
| Thu | 5 min: approve public + watch the analytics line | daily posts |
| Fri | 15 min: log the week in Daily Log (`kind=done`) | weekly content report (rows → the Friday brief picks it up) |
