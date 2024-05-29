/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/App.tsx',
    './src/components/**/*.{js,jsx,ts,tsx}',
    './src/pages/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        pressStart: ['"Press Start 2P"', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
