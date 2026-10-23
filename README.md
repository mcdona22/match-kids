# Little Star Number Flash Cards (Flutter with Riverpod Annotations)

A cross-platform early learning Flutter application built with **Riverpod
Annotations (`@riverpod`)**, **Flutter Hooks**, and **`HookConsumerWidget`** —
with **zero `StatefulWidget`s**.

## Architecture

- **Riverpod Annotations (`riverpod_annotation` & `riverpod_generator`)**:
    - `@riverpod FlutterTts tts(TtsRef ref)` in
      `lib/providers/tts_provider.dart`
    -
    `@Riverpod(keepAlive: true) class SettingsController extends _$SettingsController`
    in `lib/providers/settings_provider.dart`
    - `@Riverpod(keepAlive: true) class GameController extends _$GameController`
      in `lib/providers/game_provider.dart`
- **Zero `StatefulWidget`s**: All UI components extend `HookConsumerWidget`.
- **Flutter Hooks (`flutter_hooks`)**:
    - `useState` for transient countdown progress and Parent Zone draft inputs.
    - `useEffect` for timer intervals and controller cleanup.
    - `useMemoized` for confetti controllers.
- **20% Upper Range Challenge**: Custom stack generator ensuring exactly 20% of
  cards are drawn from the upper tier and 80% from the foundation tier,
  thoroughly shuffled with the Fisher-Yates algorithm.

## Running the App

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. (Optional) Re-run Riverpod code generation if modifying annotated providers:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Run on any device or simulator:
   ```bash
   flutter run
   ```

graphics reduction:

```bash
cwebp -q 80 assets/images/spelling.jpg -o assets/images/spelling.webp
```
