# ClawHalla.xyz

Landing page and documentation for [ClawHalla](https://github.com/deegalabs/clawhalla) — the enterprise AI agent orchestration platform.

**Live:** [clawhalla.xyz](https://clawhalla.xyz)

## Stack

- [Astro](https://astro.build) 5.x — Static site generator
- [Starlight](https://starlight.astro.build) 0.32 — Documentation framework
- [Tailwind CSS](https://tailwindcss.com) 3.4

## Development

```bash
pnpm install
pnpm dev
```

Open `http://localhost:4321`

## Build & Deploy

```bash
pnpm build    # outputs to dist/
pnpm preview  # preview production build
```

## Site Structure

### Pages

| Route | Content |
|-------|---------|
| `/` | Landing page — Hero, How It Works, Features, Agent Showcase, MC Preview, Pricing, Tech Stack |
| `/pricing` | Detailed tier comparison with FAQ |
| `/changelog` | Version history (v0.1 Docker MVP through v1.0.1 MC Hardening) |
| `/community` | Links and contribution info |

### Documentation (`/docs/`)

| Section | Pages |
|---------|-------|
| **Getting Started** | Installation, Configuration, Claude Max OAuth, Ubuntu Server Setup |
| **Guides** | Your First Agent, Customization, Content Pipeline, Autopilot |
| **Reference** | API Reference (40+ endpoints), Architecture (23 tables, security model), Docker, Environment Variables, Scripts |
| **Contributing** | How to contribute to ClawHalla |

## Key Files

```
src/
├── components/         — Landing page components (Hero, Features, Pricing, etc.)
├── content/
│   └── docs/           — Starlight documentation (MDX)
│       ├── getting-started/
│       ├── guides/
│       ├── reference/
│       └── contributing/
├── layouts/            — Page layouts
├── pages/              — Astro pages (/, /pricing, /changelog, /community)
└── styles/             — Global styles
```

## License

MIT
