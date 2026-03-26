import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  site: 'https://clawhalla.xyz',
  integrations: [
    starlight({
      title: 'ClawHalla',
      description: "Your AI agent's hall of glory. Running in one command.",
      logo: {
        src: './src/assets/logo.svg',
        replacesTitle: false,
      },
      social: {
        github: 'https://github.com/deegalabs/clawhalla',
      },
      customCss: ['./src/styles/global.css'],
      sidebar: [
        {
          label: 'Getting Started',
          items: [
            { label: 'Introduction', link: '/' },
            { label: 'Installation', link: '/getting-started/installation/' },
            { label: 'Configuration', link: '/getting-started/configuration/' },
            { label: 'Claude Max Setup', link: '/getting-started/claude-max/' },
            { label: 'Server Setup', link: '/getting-started/server-setup/' },
          ],
        },
        {
          label: 'Guides',
          items: [
            { label: 'Your First Agent', link: '/guides/first-agent/' },
            { label: 'Customization', link: '/guides/customization/' },
            { label: 'Content Pipeline', link: '/guides/content-pipeline/' },
            { label: 'Autopilot', link: '/guides/autopilot/' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'API Reference', link: '/reference/api/' },
            { label: 'Architecture', link: '/reference/architecture/' },
            { label: 'Docker', link: '/reference/docker/' },
            { label: 'Environment Variables', link: '/reference/environment/' },
            { label: 'Scripts', link: '/reference/scripts/' },
          ],
        },
        {
          label: 'Contributing',
          link: '/contributing/',
        },
      ],
      head: [
        {
          tag: 'link',
          attrs: {
            rel: 'preconnect',
            href: 'https://fonts.googleapis.com',
          },
        },
        {
          tag: 'link',
          attrs: {
            rel: 'preconnect',
            href: 'https://fonts.gstatic.com',
            crossorigin: true,
          },
        },
        {
          tag: 'link',
          attrs: {
            href: 'https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap',
            rel: 'stylesheet',
          },
        },
      ],
    }),
    tailwind({ applyBaseStyles: false }),
  ],
});
