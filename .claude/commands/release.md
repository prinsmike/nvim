---
description: Create a new release version
---

You are helping create a new release for this Neovim configuration.

This project follows Semantic Versioning (MAJOR.MINOR.PATCH):
- MAJOR: Breaking changes
- MINOR: New features (backwards compatible)
- PATCH: Bug fixes (backwards compatible)

Follow these steps:

1. Read CHANGELOG.md and show the user all unreleased changes
2. Ask the user what version number to use (or suggest one based on the changes)
3. Ask for confirmation
4. Update CHANGELOG.md:
   - Replace `[Unreleased]` with `[X.Y.Z] - YYYY-MM-DD` using today's date
   - Add a new `[Unreleased]` section at the top
   - Update the comparison links at the bottom
5. Show the user the git commands to run:
   ```bash
   git add CHANGELOG.md
   git commit -m "Release vX.Y.Z"
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin main --tags
   ```

Do NOT automatically run git commands unless the user explicitly asks you to.
