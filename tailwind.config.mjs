import starlightPlugin from '@astrojs/starlight-tailwind';
import typography from '@tailwindcss/typography';

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#C8933A',
          50: '#F7F0E3',
          100: '#EFE1C7',
          200: '#DFC38F',
          300: '#CFA557',
          400: '#C8933A',
          500: '#A67A2E',
          600: '#846123',
          700: '#624819',
          800: '#402F10',
          900: '#1E1608',
        },
        dark: {
          DEFAULT: '#0D0D0D',
          50: '#1A1A1A',
          100: '#262626',
          200: '#333333',
          300: '#404040',
          400: '#4D4D4D',
        },
        bronze: '#8B4513',
      },
      fontFamily: {
        heading: ['Cinzel', 'serif'],
        sans: ['Inter', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
  plugins: [starlightPlugin(), typography],
};
