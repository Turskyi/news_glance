# AI Agent Rules & Style Guidelines

## Core Principles

- **Brutal Honesty:** Never lie or omit critical technical concerns.
- **Explicit Typing:** Always specify types explicitly; avoid `dynamic` or
  inferred types when clarity is needed.
- **File Structure:** Every class must reside in its own dedicated file.
- **Member Ordering:** Sort class members in a logical order (Constants, Fields,
  Constructor, Public Methods, Private Methods).
  - Ensure the **caller is always above the callee**.
  - Place **public methods above private methods**.
  - Lifecycle methods should follow their execution order (e.g., `initState`
    above `build`, and **`dispose` always below `build`**).
- **Control Flow:** Prefer explicit `else` blocks for clarity.
- **Comments:** Never remove existing comments.
- **Safety:** Do not use assertions (`!`) or explicit casting (`as`). Use safe
  null-handling and type checks.
- **Magic Values:** If a hardcoded string or integer representing the same
  concept repeats more than once, it is considered a magic value and must be
  extracted into an `enum` or a global constant in an appropriate location.
- **FutureBuilder:** The `future` passed to a `FutureBuilder` must never be
  created during the `build` method. It must be obtained earlier (e.g., in
  `initState`) to avoid restarting the asynchronous task on every rebuild.

## Architecture & Persistence

- **Dependency Inversion:** Framework-specific implementations (e.g.,
  `SharedPreferences`, `Drift`, `PackageInfo`) must be encapsulated in the
  `infrastructure` layer and accessed via `abstract interface` classes defined
  in the `domain_services` layer.
- **Dependency Injection:** Prefer constructor-based dependency injection (DI)
  with Dependency Inversion Principle (DIP) over the Service Locator pattern
  (`GetIt.I`). Dependencies should be passed down from the highest level
  possible.
- **Use Case Location:** Use cases (Interactors) represent business logic and
  must reside in the `domain_services` layer, never in the
  `application_services` layer.
- **Bloc Isolation:** BLoCs must never depend on framework-specific
  implementations directly. They must only interact with `domain_services` or
  `application_services`. There is a regression test in
  `test/bloc_architecture_test.dart` to enforce this.

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
