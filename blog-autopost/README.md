# Blog Autopost Pipeline

Every article committed to the repo (and deployed to `akirusystems.com`)
auto-publishes to **LinkedIn** (title + excerpt + link) and **X** (title +
link), and gets a row in a **Google Sheet** log. New posts appear within
30 minutes of deploy, with zero manual steps.

## How it works

```
commit article → deploy to Netlify → feed.xml contains the new post
                                              │
                              n8n polls /feed.xml every 30 min
                                              │
                    Code node: new <item> not in staticData.seen?
                           │ no        │ yes
                           ▼           ▼
                          stop    LinkedIn → X → Google Sheet row
```

Deduplication: the `Filter New Posts` code node keeps a `seen` list of item
GUIDs in the workflow's **static data** — it survives restarts and re-runs.
Re-running the workflow never double-posts.

## Setup (one time, ~30 min)

### 1. n8n

Self-hosted (recommended — this is a business pipeline, not a free-tier
dependency):

```bash
docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n \
  -e GENERIC_TIMEZONE="Asia/Dubai" docker.n8n.io/n8nio/n8n
```

Or run an n8n Cloud instance. Either way: open the UI, sign in.

### 2. Import the workflow

**Workflows → Import from File** → `automation/blog-autopost/n8n-workflow.json`.
If n8n warns about node version mismatches (versions move), open each node
and re-select the latest — the structure won't change.

### 3. Credentials (create in n8n → Credentials)

| Node | Credential type | Header name | Header value |
|---|---|---|---|
| Post to LinkedIn | Header Auth | `Authorization` | `Bearer <LinkedIn user access token>` |
| Post to X | Header Auth | `Authorization` | `Bearer <X API bearer token>` |
| Log to Google Sheet | Google Sheets OAuth2 | — | (OAuth flow) |

**LinkedIn user access token:** create an app at
[LinkedIn Developer](https://developer.linkedin.com) → add product
**"Share on LinkedIn"** → generate a user access token (scopes
`w_member_social` + `r_liteprofile`). Tokens expire; when they do, mint a new
one and paste it in. (This is the documented manual path; an OAuth
automation is a documented upgrade in `TODO` terms, not required.)

**X bearer token:** [X Developer Portal](https://developer.x.com) → Projects
& Apps → Keys and tokens → API Key Set → **Bearer Token**. Posting requires a
basic-tier or higher app; free tier is read-only.

**Google Sheets OAuth2:** in n8n, create a Google Sheets credential and
complete the OAuth flow with the account that owns the log sheet.

### 4. Google Sheet

Create a sheet (e.g. "Blog Autopost Log") with these exact headers in row 1:

```
logged_at | title | link | pub_date | x_status
```

Copy the **document ID** (the long string in the sheet URL) and the tab name.

### 5. Environment variables (n8n → Settings → Execution environment / env)

| Var | Value |
|---|---|
| `LINKEDIN_AUTHOR_URN` | Your person URN — `urn:li:person:xxxxxxxxxxxx` |
| `SHEETS_DOC_ID` | The sheet's document ID |
| `SHEETS_TAB_NAME` | Tab name (default `Sheet1`) |

Finding your LinkedIn URN: with a valid token,
`curl -H "Authorization: Bearer <token>" https://api.linkedin.com/v2/me`
returns `"id": "urn:li:person:..."`.

### 6. Activate

Toggle the workflow **Active**. You can watch executions live in the UI.

## First-run behavior (important)

On the first run, *all* current feed items are "new" — the workflow will
post all existing articles. Two options:

**A — Let it post the archive (recommended).** Three quality posts on day
one is a feature, not a bug.

**B — Seed the seen list first.** In the n8n editor: **Workflow Settings →
Manage Static Data**, replace the value with:

```json
{ "seen": [
  "https://akirusystems.com/writing/article-1.html",
  "https://akirusystems.com/writing/article-2.html",
  "https://akirusystems.com/writing/article-3.html"
] }
```

then activate. First real post will be the next one you publish.

## Publishing a new post (the normal loop)

1. Add `founder-site/writing/article-N.html` (copy an existing article for
   structure; needs `<title>`, `<meta name="description">`,
   `<time datetime="...">`).
2. Add it to `writing.html` and `sitemap.xml`.
3. `node founder-site/build-feed.js` → commits a fresh `feed.xml`.
4. Commit + deploy (Netlify drag-drop, or connected repo).
5. Done. LinkedIn + X within 30 minutes; sheet row within seconds of that.

## Testing without publishing

1. In the n8n editor, click **Execute workflow**. This runs the full loop
   once (and posts anything new — see first-run behavior).
2. Verify in order: LinkedIn feed, X timeline, sheet row.
3. To retest a single post's flow without posting: open `Filter New Posts`,
   remove its GUID from static data's `seen`, and execute.

## Failure handling

- **LinkedIn 4xx:** the token is the usual suspect — expired or wrong scope.
  The run fails at the LinkedIn node; fix the credential, execute again
  (dedup still holds: the item is marked seen only after the code node ran,
  so a failed post is retried next cycle automatically).
- **X 403:** app tier is read-only — upgrade or the post is skipped.
- **Sheet errors:** check the document ID and that the headers match exactly.
- **Nothing runs:** workflow not Active, or the feed URL isn't publicly
  reachable (test `curl https://akirusystems.com/feed.xml` from a network
  that isn't the sandbox).

## What this does NOT do

- It does not post drafts. Only what's in the deployed feed.
- It does not edit or rewrite. WRITER drafts; Miss Akiru approves; the
  pipeline only distributes.
- It does not schedule. 30-minute polling is the schedule; good enough, and
  honest about it.
