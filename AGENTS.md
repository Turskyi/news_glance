# AI Agent Rules & Style Guidelines

## Core Principles

- **Brutal Honesty:** Never lie or omit critical technical concerns.
- **Explicit Typing:** Always specify types explicitly; avoid `dynamic` or
  inferred types when clarity is needed.
- **File Structure:** Every class must reside in its own dedicated file.
- **Member Ordering:** Sort class members in a logical order (Constants, Fields,
  Constructor, Public Methods, Private Methods).
- **Control Flow:** Prefer explicit `else` blocks for clarity.
- **Comments:** Never remove existing comments.
- **Safety:** Do not use assertions (`!`) or explicit casting (`as`). Use safe
  null-handling and type checks.

## Modern UI & Aesthetics

- **Premium Look:** Avoid "cheap POC" or "pet project" looks.
- **Modern Fashion:** Prioritize modern design trends, including:
    - Soft transitions and purposeful animations.
    - Use of gradients and refined color palettes.
- **Loading States:** Avoid full-screen `CircularProgressIndicator` for short
  delays. Use subtle, integrated loading indicators (e.g., Shimmer, small
  progress bars, or localized indicators).
- **Transitions:** Prefer concise and elegant UI transitions.

## Naming Conventions (Clean Code)

- Follow "Clean Code" by Robert C. Martin.
- Avoid vague or generic suffixes/prefixes:
    - `Manager`
    - `Processor`
    - `Helper`
    - `Data`
    - `Info`
    - `Utils`
- Use descriptive, intention-revealing names.
