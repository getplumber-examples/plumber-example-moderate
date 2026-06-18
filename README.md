# plumber-example-moderate — target Plumber score: **C** 🟡

[![Plumber Score](https://img.shields.io/badge/Plumber%20Score-C-d29922?style=for-the-badge&labelColor=2b2d42)](https://github.com/getplumber-examples/plumber-example-moderate/actions/workflows/plumber.yml?query=branch%3Amain)

A *realistic, imperfect* repository for the [Plumber](https://github.com/getplumber/plumber)
scanner. The main CI and release pipelines are well hardened, but a few corners were never
finished. It uses the **same** [`.plumber.yaml`](./.plumber.yaml) policy as the clean and
critical siblings — only the repo quality differs.

Expected result: **C** (≈ 59 final points).

## Where the points go (`scoring-v3`)

Run `plumber analyze --score-point` to see this table live:

| Code | Issue | Severity | Count | Loss |
| --- | --- | --- | --- | --- |
| ISSUE-701 | `dorny/paths-filter@v3` pinned by tag, not SHA (labeler workflow) | high | 1 | 15.0 |
| ISSUE-801 | labeler workflow declares no `permissions:` | medium | 1 | 6.0 |
| ISSUE-418 | labeler workflow declares no `concurrency:` | medium | 1 | 6.0 |
| ISSUE-706 | Dockerfile base pinned by tag, not digest | medium | 1 | 6.0 |
| ISSUE-601 | labeler workflow has no `name:` | low | 1 | 3.0 |
| ISSUE-902 | two Dependabot ecosystems with no cooldown | low | 2 | 4.5 |
| | | | **total loss** | **40.5** |

`finalPoints = 100 − 40.5 = 59.5` → band **C** (51–70). No Critical findings, so no malus.

> **Note (authorized-sources control).** `dorny/paths-filter@v3` is also an action from an
> owner outside the allowlist, so it now raises **ISSUE-713** (`githubActionMustComeFromAuthorizedSources`,
> high) in addition to ISSUE-701 — the labeler's unvetted third-party action is flagged on two
> axes (unpinned **and** unauthorized source). The repo still lands in band **C** under the
> current shipped control set. The point table above is the aspirational full-policy view; run
> `plumber analyze --score-point` for the live breakdown.

## What it does right (so it isn't worse than C)

- `ci.yml`, `codeql.yml`, `release.yml` are SHA-pinned, least-privilege, concurrent, and use
  `persist-credentials: false`.
- CodeQL SAST is present (`ISSUE-904` satisfied) and required-action policy passes.
- Dependabot is configured (`ISSUE-903` satisfied) and does not enable insecure code execution.
- Release uses OIDC trusted publishing behind an `environment:` gate.
- `SECURITY.md` is present.

## Fixing it back up to A

Pin `dorny/paths-filter` by SHA; add `name:`, `permissions: { ... }` and `concurrency:` to the
labeler workflow; pin the Dockerfile base by `@sha256:`; add `cooldown:` to both Dependabot
ecosystems. See `plumber-example-clean` for the finished versions.

## Run it

```bash
plumber analyze
```

> API-backed note: with an admin-scoped `gh` token, also protect `main` (see the clean repo's
> README) — otherwise `branchMustBeProtected` (ISSUE-501, critical) fires and would push the
> score to E. Without a token it abstains and the score is C as documented.
