# Writing Guide — Akiru Systems

*Derived from the three published articles (2026-06 → 2026-08). This is the
contract WRITER drafts against and Miss Akiru edits against. If a draft
breaks this guide, the draft is wrong, not the guide — but the guide can be
amended in one sentence per publication cycle, never mid-draft.*

## Voice

**First person. Direct. Cold-warm: confident, a little dry, never loud.**

The narrator is an operator who has already done the thing and is reporting
the receipts — not a guru explaining life. She never asks the reader
permission, never hedges with "maybe" or "perhaps," and never apologizes for
taking a position.

### Do

- Open with a concrete claim or a specific fact. ("In 2000, the IETF
  standardized HTTP 402." / "I run eight ventures with zero employees.")
- Use numbers and names. If a section has no number and no name, it's
  decoration.
- Short sections. 2–4 paragraphs each.
- One blockquote per article — a distilled line the reader would screenshot.
- Plain words. "Boring infrastructure with a compounding moat" > "a
  revolutionary, paradigm-shifting financial fabric."

### Don't

- No questions as openers. ("Have you ever wondered…")
- No hype vocabulary, ever: *game-changing, revolutionary, unleash, in
  today's world, landscape, journey, journey, delve, unlock* (in the
  marketing sense), *delve, leverage* (as a verb).
- No "I hope this helps." No sign-offs other than the standard footer.
- No self-promotion mid-article. The work gets mentioned once, at the end,
  in one sentence.
- No second person except to address the reader as "you" in passing. The
  article is a report, not a conversation.

## Structure (600–900 words)

```
1. Title — a claim, not a topic
   ("Solo Is a Strategy, Not a Constraint" — not "Thinking About Solo Founders")
2. Byline — date · read time · name (auto from the template)
3. Lead (1–2 paragraphs) — the claim and why it's true now
4. 3–5 sections (h2) — one idea each, §-numbered by the CSS
   Each section: claim → proof (number/name/example) → so-what
5. Closing paragraph — a short operational line. End on a fact or a decision,
   never on a question.
6. Footer — standard post-footer (auto)
```

## The one-rule test

Before publishing, read only the section titles and the first line of each
section. If that skeleton doesn't already make the argument, the article
doesn't make it. Fix the skeleton first.

## Ethics lines (non-negotiable in this house)

- When describing agent/automation work, state what is disclosed and what
  isn't. ("Every message HERMES sends is disclosed as coming from my system.")
- Public data only. If a method needs a login, a ToS bypass, or a person's
  private data, the article doesn't ship.
- No named individuals in any negative framing. Companies, markets, systems
  — yes. People — no.

## File checklist (before commit)

- [ ] `writing/article-N.html` created from the latest article template
- [ ] `<title>` is the claim; `— Miss Akiru` suffix for feed parsing
- [ ] `<meta name="description">` = the lead's second sentence, ≤160 chars
- [ ] `<time datetime="YYYY-MM-DD">` set
- [ ] Added to `writing.html` index (date, title, excerpt)
- [ ] Added to `sitemap.xml`
- [ ] `node build-feed.js` run and `feed.xml` committed
- [ ] One blockquote, zero banned words, under 900 words
- [ ] The one-rule test passed on the skeleton

Then commit + deploy. The autopost pipeline handles LinkedIn and X within 30
minutes. That's the whole publishing process.
