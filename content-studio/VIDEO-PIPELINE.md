# Video Pipeline — script → voice → slides → render → upload

One long-form (90s–3min) per week + 2–3 clips cut from it. Same pipeline,
different crop. You provide the judgment; the pipeline provides the repeat.

## 1. Script (15 min)

Use the 90-second structure from `cart402/funding/VIDEO-SCRIPT.md` as the
template — it works for brand videos too:

```
0:00–0:05  hook — one line that stops the scroll (a claim, not a greeting)
0:05–0:30  the problem, made visible (real screen, real numbers)
0:30–0:60  the mechanism — what we actually do, step by step
0:60–0:80  proof — the real product on screen, real output
0:80–0:90  the line + contact (one sentence, no hype)
```

Rules from the writing guide apply to video: no hype vocabulary, a number or
name in every section, one claim per section. If the script needs an adverb
to land, the section is wrong.

Save as `videos/{{yyyy-mm-dd}}/script.md` with a shot table (shot / VO / on-screen text).

## 2. Voice (10 min)

Three options, in order of preference:

1. **Your own voice** — record standing up, close to the mic, flat delivery.
   Phone voice memo is fine; export as MP3. (Best: it's the brand.)
2. **Agent-narrated** — ask the agent: "narrate `script.md`". The agent
   registers a voice (you pick between two auditions), generates the MP3,
   and it stays consistent across all future videos. Disclose in the
   description: "Narration: AI voice." (The disclosure is non-negotiable —
   it's the house rule.)
3. **Mixed** — you do the hook + close (0:00–0:05, 0:80–0:90), agent does
   the middle. Usually the best ratio of trust to time.

## 3. Slides (20 min)

One slide per section. Two ways:

- **Fast:** HTML files in the brand style (dark `#0b0b0c`, gold `#c9a227`,
  serif headers, monospace data — the palette is in `shared/brand/tokens.css`),
  screenshotted at 1920×1080. The agent can generate these from the script.
- **Product shots:** for "proof" sections, use real screen recordings of
  the product (Cart402 demo loop, the dashboard scan) — a real loop on a
  real product is the whole video, if you remember the funding script.

Save as `videos/{{yyyy-mm-dd}}/slides/slide-01.png` … `slide-NN.png`
(each should stay on screen 6–12s, matched to the VO).

## 4. Render

```bash
cd automation/content-studio
bash automation/content-studio/render-video.sh ../videos/2026-09-30 voice.mp4 slides out.mp4
```

`render-video.sh` builds the sequence from a per-slide duration file
(`slides/durations.txt` — one number of seconds per line, one per slide)
and mixes in the audio. 16:9 master; for Shorts, add `--vertical` to
re-render a 9:16 crop.

Manual fallback (one image per section, simple):

```bash
ffmpeg -f concat -safe 0 -i slides.txt -i voice.mp4 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest out.mp4
```

## 5. Description template (every video)

```
{one-line claim — same as the hook}

{2–3 sentences: what's on screen, what's real. "Everything shown is the
working product — {date}."}

→ {site link}
→ {blog post link, if one is the topic}

{if affiliate links are present:}
Some links below are affiliate links — if you buy through them we earn a
small commission at no cost to you. We only link tools we actually use.

{if narration is AI:} Narration: AI voice, fully disclosed.

#AI #AgenticCommerce #Founders — (max 3 tags; the rest is noise)
```

## 6. Upload

Run the **YouTube Upload** n8n workflow (form trigger): file, title,
description. It lands **unlisted** — you flip to public in YouTube Studio
after the final look. Upload the 2–3 clips as separate Shorts the same way.

## Cadence guardrail

One long-form + clips per week, every week, beats a monthly epic. If a week
dies, the daily LinkedIn/X engine keeps the channel alive — the video is a
spike, not the spine.
