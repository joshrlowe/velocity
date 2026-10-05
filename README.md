# Velocity

A game-quality 3D take on a personal portfolio, with a Bedrock-powered AI
digital twin. Designed and built by Josh Lowe as the `v2` rebuild of
jlowe.ai, then spun out into this repo in 2026-10 when jlowe.ai went back to
the v1 site. The root npm package is `velocity`; workspace packages are
`@velocity/*`.

## Where things live

| Surface                     | What it is                                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `joshrlowe/velocity` (here) | This monorepo. `main` is the Velocity tree (history carried over from `joshrlowe/jlowe.ai` branch `v2`).                         |
| `joshrlowe/jlowe.ai`        | The v1 site (Pages Router, Prisma, Vercel). Serves `https://jlowe.ai`.                                                           |
| `joshrlowe/jlowe-world`     | The Chapter 1 driving circuit, extracted from this tree on 2026-07-27.                                                           |
| `https://dev.jlowe.ai`      | Velocity preview (CloudFront/S3, `X-Robots-Tag: noindex`).                                                                       |
| `infra/terraform` (here)    | Still owns the Route53 `jlowe.ai` zone and the CI roles. In prod, `apex_external_ipv4` points the apex and `www` at Vercel (v1). |

Because this repo's Terraform owns the `jlowe.ai` zone, a `global` or `envs`
prod apply from here can change what `jlowe.ai` serves. Read the plan before
approving.

## Workspace map

```
apps/web/                  @velocity/web — Next.js static export
  src/app/(flat)/          2D marketing shell (SEO and accessibility)
  src/app/(world)/         client-only 3D host
packages/asset-pipeline/   @velocity/asset-pipeline — glTF/KTX2/Draco
packages/corpus-index/     @velocity/corpus-index — chunk, embed, retrieve
services/chat/             @velocity/chat — streaming chat Lambda
services/contact/          @velocity/contact — contact-form Lambda (SES)
infra/terraform/           global stack + envs (dev|prod) + modules
corpus/                    digital-twin markdown (not a workspace package)
scripts/                   corpus build, bundle budget, asset guard
tools/cinematic/           local Blender hero pipeline (not CI)
docs/                      architecture + runbooks
```

## Quickstart

Requires Node from `.nvmrc` (24.x) and pnpm via Corepack (`packageManager`
pins the version).

```bash
corepack enable pnpm
pnpm install
pnpm dev          # http://localhost:3000
```

`pnpm build`, `pnpm test`, `pnpm lint`, `pnpm typecheck`, and
`pnpm format:check` run across workspaces. `pnpm corpus` regenerates the
committed corpus artifacts; CI fails if they drift.

Copy [`.env.example`](.env.example) to `.env` only when you need a real
GitHub token or a live eval. The flat site boots with every value empty.
Chat and contact run in AWS, not in `pnpm dev`.

## Branch and deploy model

- Feature PRs target **`main`**.
- Web, chat, and contact deploys: `workflow_dispatch` on
  `.github/workflows/deploy-web.yml`, `deploy-chat.yml`, `deploy-contact.yml`
  (dev or prod, with GitHub environment gates). Push-to-`main` deploys stay
  off while `vars.CUTOVER_ENABLED` is `false`.
- Terraform plan runs on infra PRs; apply is a gated `workflow_dispatch`.
  Local Terraform is fmt / validate / plan only.
- `dev.jlowe.ai` is the Velocity preview host (`X-Robots-Tag: noindex` from
  the dev distribution). App code does not special-case that header.

## World code and `jlowe-world`

The interactive Chapter 1 driving circuit (coastal track, vehicle, hero race)
lives in the sibling repo `joshrlowe/jlowe-world` (named in this tree's world
comments; it is not a directory here). Its asset attributions moved with it
(`LICENSES.md`).

This repo still owns:

- `apps/web/src/components/world/**` — renderer shell (WebGPU with a WebGL2
  fallback), the in-transit starfield, the `?scene=fixture` harness, and the
  chapter FSM / HUD machinery. The chapter registry is empty while Chapter 2
  (“Escape Velocity”) is built. These files are live; they are not a dead copy
  of the extracted circuit.
- `tools/cinematic/**` — headless Blender pipeline for a pre-rendered hero.
  It stays here. It is local-only (never CI) and is not the drivable world.

Do not move those trees across repos in a hygiene PR.

## Further reading

- [`docs/runbooks/cutover.md`](docs/runbooks/cutover.md) — historical: how the apex moved to CloudFront in 2026-07
- [`docs/architecture.md`](docs/architecture.md) — how web, chat, contact, and corpus fit together
- [`CLAUDE.md`](CLAUDE.md) — agent-facing standing rules
- [`LICENSES.md`](LICENSES.md) — third-party asset attributions (separate from the MIT `LICENSE`)
