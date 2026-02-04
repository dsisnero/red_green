# Changesets

This project uses a lightweight changeset flow to keep release notes accurate
without requiring a full release toolchain.

## When to add a changeset

Add a changeset for any user-visible change:

- new APIs or behavior
- performance improvements
- bug fixes
- documentation that affects usage

## How to add a changeset

1. Create a new file in `.changeset/` with a short descriptive name.
2. Use the template in `.changeset/template.md`.
3. Update `CHANGELOG.md` when preparing a release.

## Why this exists

Keeping a short, focused changeset per change makes it easier to curate a
release without losing details during development.
