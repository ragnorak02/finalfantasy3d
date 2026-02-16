# Git Workflow — Korean Fantasy RPG

## Quick Reference

### "Please commit everything" — What Happens

1. **`git status`** — Review all changed/untracked files
2. **Secret scan** — Automated scan for credentials, keys, tokens, .env files
3. **If secrets found** → STOP, warn user, list files, recommend .gitignore additions
4. **If clean** → Stage intended files (`git add` specific files, not `-A`)
5. **Commit** with message: `chore(checkpoint): <description>`
6. **Push** only if remote `origin` exists and auth succeeds
7. **Report** actual outcome — never claim success without confirmation

---

## Commit Message Format

```
<type>(<scope>): <short description>

<optional body>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

### Types
| Type | Use |
|------|-----|
| `feat` | New gameplay feature or system |
| `fix` | Bug fix |
| `refactor` | Code restructure without behavior change |
| `chore` | Project maintenance, checkpoints, config |
| `assets` | New or updated art/audio/model assets |
| `docs` | Documentation changes |
| `ui` | UI/HUD changes |
| `vfx` | Visual effects changes |

### Scope Examples
`player`, `combat`, `abilities`, `camera`, `ui`, `enemies`, `audio`, `checkpoint`

---

## Secret Scan Protocol (CRITICAL)

Before **every** commit, scan the workspace for:

| Pattern | Description |
|---------|-------------|
| `.env`, `.env.*` | Environment variable files |
| `*.key`, `*.pem`, `*.p12`, `*.pfx` | Private key / certificate files |
| `-----BEGIN.*PRIVATE KEY-----` | Embedded private key blocks |
| `AKIA[0-9A-Z]{16}` | AWS access keys |
| `sk-[a-zA-Z0-9]{20,}` | OpenAI / Stripe secret keys |
| `ghp_`, `gho_`, `github_pat_` | GitHub tokens |
| `password\s*=\s*["'][^"']+` | Hardcoded passwords |
| `secret\s*=\s*["'][^"']+` | Hardcoded secrets |
| `*.sqlite`, `*.db` | Database files (may contain data) |
| `credentials.json`, `service-account*.json` | Cloud credentials |

**If ANY match is found:**
- Do NOT proceed with the commit
- List every suspicious file with the match reason
- Suggest `.gitignore` additions
- Require explicit user confirmation before continuing

---

## .gitignore Coverage

The project `.gitignore` protects against:
- Godot caches (`.godot/`, `*.import`)
- Secrets (`.env`, `*.key`, `*.pem`, `*.p12`, `*.pfx`)
- Credentials (`credentials.json`, `service-account*.json`)
- Database files (`*.sqlite`, `*.db`)
- Node.js (`node_modules/`)
- Build artifacts (`build/`, `dist/`, `export/`)
- OS junk (`.DS_Store`, `Thumbs.db`)
- IDE files (`.vscode/`, `.idea/`)

---

## Push Behavior

- Push **only** when explicitly requested or as part of "commit everything" flow
- Push targets `origin` remote only
- If push fails (auth, network), print the exact error and next steps
- **Never** force push (`--force`) without explicit user request
- **Never** push to `main`/`master` with `--force`

---

## Safety Warnings

- **Never** amend published commits unless explicitly asked
- **Never** run `git reset --hard` or `git clean -f` without confirmation
- **Never** delete branches without confirmation
- **Never** skip pre-commit hooks (`--no-verify`) without explicit request
- Always create NEW commits rather than amending on failure
- Stage specific files by name — avoid `git add -A` to prevent accidental inclusions

---

## Branching (When Applicable)

```
main              — stable checkpoints
feat/<name>       — feature branches
fix/<name>        — bug fix branches
```

Current workflow: direct commits to `main` (single developer, prototype phase).
Introduce branching when collaborators join or for risky changes.
