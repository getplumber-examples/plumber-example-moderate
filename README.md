# plumber-example-moderate — target Plumber score: **C** 🟡

[![Plumber Score](https://score.getplumber.io/github.com/getplumber-examples/plumber-example-moderate.svg)](https://score.getplumber.io/github.com/getplumber-examples/plumber-example-moderate)

A *realistic, imperfect* repository for the [Plumber](https://github.com/getplumber/plumber)
scanner. The main CI and release pipelines are well hardened, but the labeler workflow was
never finished. It uses the **same** [`.plumber.yaml`](./.plumber.yaml) policy as the clean and
critical siblings — only the repo quality differs.

Scanned with Plumber **v0.4.3**. Expected result: **C** (58 final points).

## Where the points go (`scoring-v3`)

Run `plumber analyze --score-point` to see this live. Every finding is in the one unfinished
workflow, [`labeler.yml`](./.github/workflows/labeler.yml):

| Code | Issue | Severity | Count | Loss |
| --- | --- | --- | --- | --- |
| ISSUE-701 | `dorny/paths-filter@v3` pinned by tag, not a 40-char SHA | high | 1 | 15.0 |
| ISSUE-713 | `dorny/paths-filter` is from an owner outside the authorized allowlist | high | 1 | 15.0 |
| ISSUE-402 | `dorny/paths-filter@v3` — `v3` resolves upstream as **both** a tag and a branch (ref-confusion) | medium | 1 | 6.0 |
| ISSUE-801 | labeler workflow declares no `permissions:` block | medium | 1 | 6.0 |
| | | | **total loss** | **42.0** |

`finalPoints = 100 − 42 = 58` → band **C** (51–70). No Critical findings, so no malus.

The unvetted third-party action is flagged on three axes at once — unpinned (701), unauthorized
source (713), and an ambiguous `v3` tag/branch ref (402) — which is exactly why "just add a
labeler" is where real repos quietly slip from A to C.

## What it does right (so it isn't worse than C)

- `ci.yml`, `codeql.yml`, `release.yml` are SHA-pinned, least-privilege, concurrent, and use
  `persist-credentials: false`.
- CodeQL SAST is present and the required-action policy (`workflowMustIncludeRequiredActions`)
  passes.
- Release uses OIDC trusted publishing behind an `environment:` gate, and the publish job does
  **not** restore a shared build cache (so no cache-poisoning finding, ISSUE-705).
- No injection surface, no `toJson(secrets)`, no writes to `$GITHUB_ENV` from user input.
- `SECURITY.md` is present.

## Fixing it back up to A

In `labeler.yml`: pin `dorny/paths-filter` by 40-char commit SHA (clears 701 **and** 402, since a
SHA is unambiguous), add it to `trustedGithubActions` in `.plumber.yaml` or swap it for an
allowlisted action (clears 713), and add an explicit `permissions:` block (clears 801). See
`plumber-example-clean` for the finished versions.

## Run it

```bash
plumber analyze
```

> API-backed note: with an admin-scoped `gh` token, also protect `main` (see the clean repo's
> README) — otherwise `branchMustBeProtected` (ISSUE-501, critical) fires and would push the
> score to E. Without that scope it abstains and the score is C as documented.
