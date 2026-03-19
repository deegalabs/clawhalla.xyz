# clawhalla.xyz

Landing page and documentation for [ClawHalla](https://github.com/deegalabs/clawhalla) — a Docker-based launcher for OpenClaw.

**Live**: [clawhalla.xyz](https://clawhalla.xyz)

## Pages

- `/` — Landing page with Quick Start
- `/docs` — Full documentation (Starlight)

## Tech Stack

- [Astro](https://astro.build/) — Static site generator
- [Starlight](https://starlight.astro.build/) — Documentation
- [Tailwind CSS](https://tailwindcss.com/) — Styling
- GitHub Pages — Hosting

## Development

```bash
npm install
npm run dev
```

## Build

```bash
npm run build
npm run preview
```

## Deploy

Automatically deployed to GitHub Pages on push to `main`.

## Install Scripts

The site hosts installer scripts at:

- `https://clawhalla.xyz/install.sh` — Full installer with onboard
- `https://clawhalla.xyz/install-docker.sh` — Docker setup only

## Related

- [ClawHalla](https://github.com/deegalabs/clawhalla) — Main Docker repository
- [OpenClaw](https://openclaw.ai) — The AI agent framework

## License

MIT
