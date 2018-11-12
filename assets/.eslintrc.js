module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es6: true
  },
  globals: {
    React: true,
    feather: true,
    ReactDOM: true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended"
  ],
  parserOptions: {
    sourceType: "module"
  },
  rules: {
    "no-console": ["error", { allow: ["warn", "error", "log"] }],
    quotes: ["error", "double"],
    semi: ["error", "always"],
    "react/prop-types": ["never"]
  }
};
