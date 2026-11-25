# Agent Guidelines

## Configuration

This repository contains configuration that is personalized to the repository author. Tailor changes to his preferences and workflow. In general, keep machine- and environment-specific settings local and untracked.

## Code Separation

Any repository related code should go in `scripts/`. `bin/` is reserved for general-purpose utilities added to PATH, which are typically unrealated to this repository. Content in `scripts/` should not be added to PATH.

## Style

Write comments sparingly, only where the intent isn't obvious from the code. Keep them concise.

## Documentation

Do not create documentation files (READMEs, guides, notes, etc.) unless explicitly asked. When editing documentation, favor smaller changes, try to match the style of existing writing.
