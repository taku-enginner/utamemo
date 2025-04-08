module.exports = {
  content: [
    "./app/javascript/**/*.{js,jsx}", // すべてのJS、JSXファイルをスキャン
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/views/**/*',
  ],
  future: {
  },
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["light", "dark", "cupcake", "aqua", "pastel"],
  },
};