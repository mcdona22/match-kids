# Little Star (Flutter with Riverpod Annotations)

## Deployment

```bash
flutter build web --release --pwa-strategy=none --dart-define=APP_VERSION="$(date +%s)"
firebase deploy --only hosting
````

```bash
flutter build web --release  --dart-define=APP_VERSION="$(date +%s)"
firebase deploy --only hosting
```

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
