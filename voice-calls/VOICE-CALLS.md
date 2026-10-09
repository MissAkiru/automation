# Voice Calls — "the c3x thing"

**What you saw is 3CX** (three-c-X) — a phone system (PBX) that in its 2026
**AI Edition** ships an AI Receptionist, AI Personal Assistant, and AI
Agents that can handle and make calls. Key facts (2026 pricing):

| 3CX plan | Cost | AI? |
|---|---|---|
| SMB Free | free, up to 10 users | **No** — basic PBX only |
| Basic / PRO | ~$330–440/yr (8 simultaneous calls) | No AI Receptionist |
| **AI Edition** | **~$635/yr** (8 SC) + hosting/SIP | AI Receptionist, AI Assistant, AI Agents, transcription |

## The honest recommendation

**You don't need 3CX yet.** The thing you want — *"an AI agent that calls
me on my phone"* — is an **outbound call to a mobile number**. A PBX is
useless for that on its own. Two stages:

### Stage 1 (this week, ~$2/mo): Twilio + n8n Voice

- n8n has a native **Voice node** (Twilio-based). The workflow
  `n8n-morning-call.json` is built: every day at 08:00 Dubai it reads the
  latest briefing from the Briefings sheet tab, trims it to the two sections
  that matter on a phone (Today's Tasks + Needs Our Attention), and **calls
  your mobile** — a disclosed automated voice saying the brief.
- Setup: K9 (Twilio account + a number you can receive on), n8n Twilio
  credential, env `CALL_TO` (already set to your number in
  `automation/.env.example`), activate.
- Rules (guardrails, in writing):
  - Every call opens with: *"This is an automated call from your own
    systems, Akiru Systems."* — disclosure, every time, no exceptions.
  - Outbound to **your** numbers only, until we build a reviewed dialer for
    clients. Calling third parties = consent + disclosure + a human loop,
    and that's a project, not a toggle.
- Cost reality: ~$0.08/min + ~$1/month number. A 2-minute brief ≈ 17 cents.

### Stage 2 (when you want a real business line): 3CX AI Edition

Trigger conditions (any one):
- you want a **business number** with IVR ("sales / press / main")
- you want **inbound** calls answered by an AI receptionist while you're
  in a call
- you add staff (even one) who needs an extension

Then: 3CX AI Edition (~$635/yr), SIP trunk, 2–3 extensions. The n8n
workflows keep working — n8n can bridge to 3CX via SIP/Twilio, and 3CX's
own AI agents handle the inbound deflection. Don't pay for Stage 2 to do
Stage 1's job.

## The morning call — what it sounds like

```
"Good morning, Miss Akiru. This is an automated call from your own systems,
Akiru Systems. Two-minute brief.

Today's tasks: [up to 3, from the Daily Log].
Needs attention: [up to 2, from the brief].

That's the picture. Full brief is in your inbox. Have a good day."
```

Two minutes, hard cap. If the brief section is empty, the call says so in
one line and ends. A call that rambles is a call you stop answering — and
if you stop answering, the system is broken.

## Files

- `n8n-morning-call.json` — the workflow (schedule 08:00 → read latest
  briefing → trim → Twilio voice call).
- `automation/.env.example` — `CALL_TO` (your number, +971 format).
