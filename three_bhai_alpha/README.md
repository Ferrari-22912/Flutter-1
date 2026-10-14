# 3Bhai — slide-based rebuild

**Three brothers. One kitchen. Zero food waste.**

The original alpha app's screens, logo, orange gradient, colors, fonts, rounded
cards, ingredient tiles, labels and sample content have been retained. Its state
management is rebuilt around the concepts in the three Flutter lecture decks.

## Architecture

```text
main() → runApp() → GetMaterialApp → screens → shared widgets
                                     ↓
                            GetX controllers (Rx)
                                     ↓
                               repositories
                                     ↓
                           built-in sample data
```

`Obx` rebuilds widgets when a controller's observable view state changes.
`Get.put` registers repositories/controllers and `Get.find` retrieves them.
Route bindings own page-controller lifetimes; authentication and repositories
live for one app session. Forms retain local `setState` for login/sign-up mode
and password visibility. Text, scroll and worker resources are disposed with
their owning screens.

```text
lib/
  main.dart        entry point
  app.dart         registration, route bindings and navigation
  models/          plain Dart data classes
  controllers/     GetX state and user actions
  repositories/    data operations, isolated from widgets
  data/            recipe source and built-in recipes
  screens/         login, ingredients, results, history, chat
  widgets/         reusable original UI components
  core/            theme, shared button, validators, configuration and errors
```

No BLoC/Cubit, Equatable or use-case layer is required. `google_fonts` is kept
solely to preserve the original DM Sans and Bricolage Grotesque typography.
See [the lecture mapping](docs/SLIDE_MAPPING.md) for the slide references.

## Included flows

| Flow | Content/behavior retained |
|---|---|
| Login / sign up / logout | Validated forms, loading/error states, demo autofill |
| Ingredients | 99 items, category filters, search, multi-select, show-all toggle |
| Recipes | 15 sample recipes, top 10 ranked matches, missing ingredients, detail sheet |
| History | Four seeded searches, saved results, swipe deletion and clear confirmation |
| Chef Bhai | Seeded chat, suggestions, keyword-based replies, clear confirmation |

**Demo login:** `chef@threebhai.app` / `Chef1234`. Tap the demo banner to fill
these values. As in the original alpha, other valid email/password combinations
also work; an email containing `fail` previews an authentication error.

This is **demo authentication, not real account security**. Chef Bhai is not an
AI service. History and chat are account-specific in memory and survive logout
within the same running app, but reset after app restart. No passwords are saved.
The first use of the original fonts requires internet; the ingredient/recipe/chat
data does not require a backend or API keys.

## Setup and run

Install Flutter, the IDE Flutter/Dart extensions and Android SDK tools as covered
in the lectures. Run `flutter doctor` and resolve reported Android setup issues.
The workflow pins Flutter **3.29.3** and Java **17**; the manifest requires Dart
3.6 or newer.

From this directory:

```sh
# The lite ZIP omits generated Gradle launch scripts. Create missing scaffolding:
flutter create --org com.threebhai --project-name three_bhai --platforms=android .
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run
flutter build apk --release
```

Do not use `--overwrite`; keep the existing app ID, logo and Android files.
The APK is generated at `build/app/outputs/flutter-apk/app-release.apk`.
Release builds still use the original **debug signing** configuration, so this
is a classroom/demo APK, not a Play Store release.

## Checks

From the repository root:

```sh
python3 tools/check_rebuild.py
```

This checks original UI string/number literals, byte-identical logo/platform
assets, retained ingredient/recipe sample data, local imports and removal of old
state-management dependencies. It is **not** a pixel comparison or Dart analyzer.

The Flutter tests cover validators, the catalog, sample recipe ranking, auth
success/failure/sign-up/logout, ingredient filtering/selection, chat failure
recovery, history deletion/account isolation, saved recipe searches, stale
search responses, disposed controllers, UI interaction and route cleanup.

Local checks completed during the rebuild:

- Original UI string/number literals retained in 15 UI files.
- All 25 supplied asset/platform files retained byte-for-byte.
- Ingredient and recipe sample-data literals retained.
- Imports resolve in all 57 Dart source/test files; no BLoC/Equatable references.
- All 57 Dart files parsed successfully and were formatted with a Dart formatter.

**Flutter analysis, widget/unit execution and APK compilation remain unverified
locally** because the workspace has no Flutter/Dart SDK. The repository-level
[GitHub Actions workflow](../.github/workflows/flutter.yml) is configured to run
those checks and publish the APK as an artifact; no workflow run is claimed here.
