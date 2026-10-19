# GitHub Copilot Project Guidelines

This project contains interactive educational tools built with Flutter and Dart.
Keep implementations concise, practical, and functional—focusing on clean code
that fulfills requirements without unnecessary over-engineering.

---

## 1. Project Structure (Feature-First)

Organize code by feature under `lib/src/features/`. Avoid layer-first directory
structures (`lib/controllers`, `lib/views`).

```text
lib/
  ├── src/
  │   ├── common_widgets/   # Shared, generic UI components
  │   ├── constants/        # App-wide theme, colors, strings, constants
  │   ├── utils/            # Shared helper functions/utilities
  │   └── features/
  │       └── [feature_name]/
  │           ├── data/     # Repositories, data sources, DTOs
  │           ├── domain/   # Models, business logic, value objects
  │           └── presentation/
  │               ├── controllers/  # Riverpod AsyncNotifier / Notifier
  │               └── widgets/      # Feature-specific screens and UI widgets
  └── main.dart             # App entry point with ProviderScope

```

## State Management Rules (Riverpod Code Generation)

* Always use `flutter_riverpod` with `riverpod_annotation` (`build_runner` code
  generation).
* Always annotate providers with `@riverpod` or `@Riverpod()`. Do not use legacy
  unannotated providers like `StateNotifierProvider` or
  `ChangeNotifierProvider`.
* Extend generated classes (`_$NotifierName`) for all notifier state classes.
* Prefer functional `@riverpod` providers for simple read-only/computed state,
  and `@riverpod` class notifiers for mutable state.
* Handle async states explicitly using `AsyncValue` pattern matching (`.when()`,
  `.maybeWhen()`, or `.listen()`).
* Keep UI widgets pure and declarative; keep state logic inside controllers.

---

## UI, Theme & Styling Conventions

* **Theme:** Use Material 3 with `ColorScheme.fromSeed(...)`. Reference semantic
  color roles (`Theme.of(context).colorScheme.primary`, `surface`, etc.) rather
  than hardcoded colors. Support light and dark themes.
* **Typography:** Always use standard Material 3 typography tokens via
  `Theme.of(context).textTheme` (e.g., `headlineSmall`, `titleLarge`,
  `bodyMedium`). Do not hardcode font sizes or colors in custom `TextStyle`
  instances unless strictly required.
* **Widgets:** Always use `const` constructors for widgets whenever possible.

---

## Dart Code Conventions

* Use modern Dart features: pattern matching, `switch` expressions, records, and
  exhaustive checks.
* Use `@freezed` or immutable classes with `copyWith` patterns for domain
  models.
* Keep functions concise, self-documenting, and strongly typed.

## General implementation notes

* Dont use stateful widgets, instead use HookConsumerWidgets with hooks
  and/or signals
* use composition aggressively and decompose widgets to support this. It is
  oK to use private classes as widgets that are entirely local but the
  source file should not be permitted to get too large in this regardless of
  the merits of class privacy
* use enumerations generously and constructors that permit useful attributes
  such as human readable labels for the same

## Component & Architecture Design Principles

* **Prefer Composition over Monoliths:** Break down complex screens into small,
  private or feature-level sub-widgets. No single build method should exceed 50
  lines of code.
* **Single Responsibility per File:** Keep domain models, Riverpod controllers,
  and UI components in separate files following the feature-first folder layout.
* **Extracted Widgets over Helper Methods:** Never create
  `Widget _buildSection()` helper methods inside a widget class. Extract them
  into standalone `const StatelessWidget` or `ConsumerWidget` classes to allow
  Flutter's element tree to optimize rebuilds.