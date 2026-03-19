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
            { label: 'Introduction', link: '/docs/' },
            { label: 'Installation', link: '/docs/getting-started/installation/' },
            { label: 'Configuration', link: '/docs/getting-started/configuration/' },
          ],
        },
        {
          label: 'Guides',
          items: [
            { label: 'Your First Agent', link: '/docs/guides/first-agent/' },
            { label: 'Customization', link: '/docs/guides/customization/' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'Scripts', link: '/docs/reference/scripts/' },
            { label: 'Docker', link: '/docs/reference/docker/' },
            { label: 'Environment Variables', link: '/docs/reference/environment/' },
          ],
        },
        {
          label: 'Contributing',
          link: '/docs/contributing/',
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
