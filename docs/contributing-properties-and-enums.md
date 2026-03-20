# Contributor Guide: Adding Properties and Enums

Use this workflow when introducing new CSS properties or enum values.

## 1) Choose the property shape

Inspect the CSS syntax and decide which helper macro to use in `src/stylesheet.cr`:

- `prop` for one value
- `prop2`..`prop6` for multi-value forms
- custom helper methods when the syntax is function-like or highly overloaded

Example:

```crystal
prop object_fit, CSS::Enums::ObjectFit
```

## 2) Add or update enums

If the property is enum-backed, define/update enums in `src/css/enums/*.cr` using `css_enum`.

Example:

```crystal
css_enum ObjectFit do
  Fill
  Contain
  Cover
  None
  ScaleDown
end
```

`css_enum` automatically provides `to_css_value`, converting enum members into kebab-case CSS values.

## 3) Wire the property to enum/value types

In `src/stylesheet.cr`, choose strict types when possible:

- enum unions for keyword values
- typed units (`CSS::Length`, `CSS::LengthPercentage`, etc.)
- helper types (`Color`, gradient/image function call aliases)

Prefer typed overloads over raw `String` paths.

## 4) Add focused specs

Create or update `spec/*_spec.cr` to cover:

- happy path rendering
- enum value rendering
- combinations/overloads where relevant
- edge cases (`important: true`, multi-value ordering, nesting/media interactions) when applicable

## 5) Update docs and coverage

- If user-facing behavior changed, update relevant files in `docs/`.
- Run `crystal scripts/generate_coverage.cr` when property support status changes and commit `COVERAGE.md` updates if needed.

## 6) Run checks

```bash
crystal tool format
crystal spec
```

## Optional helper script

`scripts/generate_props.cr` prints `prop ...` stubs from MDN data and can accelerate initial scaffolding. Treat this output as a starting point; refine to typed APIs before committing.
