module.exports = {
  content: [
    "./app/javascript/**/*.{js,jsx}", // すべてのJS、JSXファイルをスキャン
    "./app/views/**/*.html.erb", // すべてのerbファイルをスキャン
    "./app/helpers/**/*.rb", // すべてのrbファイルをスキャン
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