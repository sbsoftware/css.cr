# Repository Guidelines

## Project Structure & Module Organization
- Library code lives in `src/`; DSL primitives are under `src/css/` with enums in `src/css/enums/`, shared macros in `src/macros.cr`, and the public entrypoint in `src/css.cr`.
- Specs are in `spec/`, mirroring the feature areas (`selector_spec.cr`, `media_spec.cr`, etc.) and bootstrapped via `spec/spec_helper.cr`.
- Utility scripts sit in `scripts/`; `scripts/generate_props.cr` is a helper to print property declarations from MDN data.

## Build, Test, and Development Commands
- Install deps: `shards install`.
- Run the suite: `crystal spec` (use `crystal spec spec/selector_spec.cr` to focus).
- Format code: `crystal tool format` before opening a PR.
- Optional: `crystal docs` to build API docs locally.

## Coding Style & Naming Conventions
- Crystal defaults: 2-space indentation, trailing commas avoided, and `require` paths are relative to `src/`.
- Types, modules, and DSL classes use `CamelCase`; methods, variables, and files use `snake_case` (mirrors existing files like `media_query_evaluator.cr`).
- Prefer expressive DSL method names that match CSS terms; keep rule blocks small and composable.
- Keep public API additions documented in comments only when behavior is non-obvious; otherwise rely on self-descriptive method names.

## Testing Guidelines
- Use the built-in `spec` framework; each feature gets a `*_spec.cr` in `spec/`.
- Name examples to describe rendered CSS output (see `nested_rule_spec.cr`); include both structure and value assertions.
- When adding syntax or properties, extend or add focused specs rather than modifying many files at once.
- Aim to cover both rendering and nesting/combination behaviors for new selectors or declarations.
- If you don't have permissions to run the tests, don't try any workarounds - just skip the tests

## Security & Configuration Tips
- The repo uses only Crystal stdlib; avoid adding new networked dependencies without discussion.
- If you must refresh property data, run `crystal scripts/generate_props.cr` in a sandboxed environment and commit only the resulting code changes, not downloaded data.
