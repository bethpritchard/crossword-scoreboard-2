module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: ['plugin:@typescript-eslint/recommended-type-checked'],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  parserOptions: {
    project: ['./tsconfig.json'],
  },
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
    },
  ],
};

