# Affiliate Strategy — Akiru Systems

**The rule that makes everything else work:** we only put an affiliate link
on a tool we actually run, and every placement is disclosed. One violation of
either half and the trust the whole brand is built on takes a write-off
damage you can't claw back.

## Where affiliate links live

| Placement | What | Notes |
|---|---|---|
| **YouTube descriptions** | Tools used in that specific video | Plus the pinned comment. Disclosure line in the description template (VIDEO-PIPELINE.md) is mandatory. |
| **Blog posts** | Only where the post genuinely uses/recommends the tool | In-text link + the `/affiliates` page as the standing disclosure. |
| **`/affiliates` page** (on the site) | The standing list + disclosure | Built: `founder-site/affiliates.html`. Current state: "accounts in setup" — links get added as accounts approve. |
| **LinkedIn / X** | Never in cold DMs; only in our own posts/profile, marked | Platforms allow it with disclosure (`#ad` / "affiliate link" plainly). |

**Nowhere else.** No link-in-bio spam, no comment-section drops, no
auto-generated "best tools" lists we didn't write.

## Which programs (fit first, commission second)

Tier 1 — things we run daily (apply first, highest trust):
- **The stack we sell** (see `services/STACK.md`): n8n, Supabase, Postgres —
  check PartnerStack / Impact / each vendor's program for affiliate terms.
- **Voice/calls**: **3CX** has a partner network (the phone system we're
  evaluating); **Twilio** referral economics are weak but the partner
  program is worth the reseller angle later.
- **AI APIs** (OpenAI/Anthropic/Google don't do classic affiliates — the
  money is in usage, which our clients pay; don't fake this one).

Tier 2 — tools we recommend to clients:
- Creator/video: Descript, Synthesia, Captions — all have programs (Impact
  or in-house).
- Writing/publishing: Jasper, Writesonic, Grammar Business — check terms.
- Hosting/web for our SME builds: any we'd actually stand behind.

Tier 3 — hardware (the creator angle): Amazon Associates for mics/cameras if
the video channel takes off. Low commission, high trust cost if we link
junk — the bar is "would we put this in a client's hands."

## The application order (this month)

1. **PartnerStack.com** — one account, most AI/SaaS tools live there.
2. **Impact.com** — the second big network.
3. **3CX partner page** — pairs with the voice-calls rollout.
4. Amazon Associates only when the video channel has ≥5 uploads.

Keep a row per program in the sheet: `program | network | rate | status |
where links live | approved-date`.

## Compliance (the part that keeps the brand clean)

- **FTC (and equivalent everywhere we operate):** clear and conspicuous
  disclosure, before the link, in plain words. Our standard line:
  *"Some links are affiliate links — if you buy through them we earn a small
  commission at no extra cost to you. We only link tools we actually use."*
- **Platform rules:** YouTube requires disclosure in the video UI *and* the
  description (the "Disclosure" toggle); LinkedIn/X: mark in the post.
- **Never** imply an endorsement we can't stand behind; never link a tool
  mid-DM; never bury the disclosure below the fold.
- One page, one line, one habit: `/affiliates` + the description template +
  "would we put this in a client's hands?"

## Payout discipline

- Payouts go to the business account, tracked in the Daily Log
  (`kind=done`, owner=me, text="affiliate: $X — {program}").
- Quarterly: kill any program with 12 months and <3 conversions. A dead
  affiliate link is a small daily tax on the page it sits on.
