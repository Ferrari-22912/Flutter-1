# Lecture review and implementation mapping

## Files reviewed

All six PPTX files were inspected. Each `(1)` deck has the same SHA-256 hash as
its corresponding unnumbered deck, so there are three unique lectures, totaling
**116 slides**. Lecture 1 contains editable text; Lectures 2 and 3 contain slide
images, which were extracted and read using OCR. OCR is imperfect for some small
code snippets, so the implementation follows the concepts rather than copying
OCR-damaged code.

| Unique deck | Slides | Focus |
|---|---:|---|
| `Flutter Lecture 1.pptx` | 37 | Flutter setup, architecture, widget/element trees, stateless/stateful widgets, lifecycle, main/runApp, hot reload |
| `Flutter_Lecture_2 .pptx` | 44 | Project organization, themes, core widgets, lists/grids, local state, external packages and GetX |
| `Flutter_Lecture_3.pptx` | 35 | XAMPP/MySQL teaching demo, Android setup, models/repositories/GetX/screens, validation, filtering and account isolation |

The original ZIP is the **UI and sample-data reference**. The lecture slides are
the **implementation-concept reference**. The expense tracker pictured/described
in Lecture 3 does not replace the 3Bhai recipe app.

## How the slides are applied

| Slide concept | References | Where it is used |
|---|---|---|
| `main → runApp → root widget → Scaffold` | L1: 21–22, 30–32; L2: 4–6, 26 | `lib/main.dart`, `lib/app.dart`, each screen |
| Widget composition / stateless presentation | L1: 12–15, 31–34; L2: 16–18, 21, 27–29 | Reused header, button, tile, recipe card, detail-sheet and chat-bubble widgets |
| Local mutable state with `setState` | L1: 16, 35; L2: 28–32, 42 | Login/sign-up mode in `screens/auth_page.dart`; password visibility in `widgets/auth_text_field.dart` |
| Lifecycle ownership and cleanup | L1: 17; L2: 19, 30, 43 | Form/scroll controllers and GetX workers created once, disposed on screen removal; closed-controller guards for async completion |
| App-wide ThemeData / typography / color scheme | L2: 10–15 | Original `core/theme/app_theme.dart` and `app_colors.dart` |
| Asset declaration and image widgets | L2: 18 | Original `assets/images/logo.png`, asset registration in `pubspec.yaml`, recipe emoji tiles and network-image fallbacks |
| Text input, controllers, buttons and validation | L2: 19–20; L3: 25 | Auth form, ingredient search, chat composer, loading/disabled buttons, original validators |
| Lists and builder-based grids | L2: 22–25; L3: 26 | Ingredient `GridView.builder`; history and recipe `ListView.separated`; chat message list |
| Packages declared in pubspec | L2: 33–35 | `get` replaces BLoC/Equatable; existing `google_fonts` preserves typography |
| GetX controller, Rx and Obx | L2: 36–37, 39, 41; L3: 24 | `controllers/*_controller.dart`; reactive view states observed by screen `Obx` builders |
| Dependency registration and retrieval | L2: 38 | `AppBinding`, route `BindingsBuilder`, `Get.put` and `Get.find` in `app.dart` and screens |
| Consistent GetX navigation | L2: 40–41; L3: 24, 27, 29 | `GetMaterialApp`, `Get.to`, `Get.back`, `Get.offAllNamed`; native Flutter dialog/sheet widgets remain unchanged |
| Models, repositories, controllers and screens | L2: 5; L3: 19–22 | Flattened `lib/models`, `repositories`, `controllers`, `screens`, with sample data kept outside widgets |
| Account-specific data access | L3: 23 | History/chat stores keyed by the authenticated user's ID; state belongs to app repository instances, not static cross-app stores |
| Safe Android toolchain setup | L1: 18–20, 28–29; L3: 14–18 | Original Android config retained; build instructions and CI use Java 17 and Flutter's SDK/NDK settings |
| Debugging, hot reload and automated checks | L1: 23–26, 37; L2: 7–9, 43–44; L3: 32, 34 | Documented run commands, retained/expanded tests and root CI workflow |

## Topics intentionally not turned into new app features

Some slides describe development tools or a different example application, not
features the recipe UI needs. Applying them blindly would change the requested
UI or introduce credentials/network prerequisites.

- **XAMPP, phpMyAdmin and direct MySQL** (L3: 4–13, 20–23): the sample repositories
  remain offline. The separation between UI, controller and repository is
  applied, but no database socket, SQL account or database credentials are added.
  A real backend would replace the repository implementation rather than the UI.
- **Expense add/update, date range and location filtering** (L3: 3, 23, 27–29):
  these belong to the lecture's finance tracker, not 3Bhai. Existing recipe
  filtering, history save/delete and details navigation remain in their place.
- **Google Maps/Places** (L3: 29–31): no map screen, billing requirement or API key
  is introduced, because the supplied recipe app has no location flow.
- **Production security** (L3: 5, 13, 33): the app is clearly documented as a demo.
  Real authentication must use a backend API, with server-side password hashing,
  authorization and validation. Direct MySQL credentials must not ship in a
  production Flutter app; browsers cannot open MySQL sockets.
- **Hot reload, emulators and IDE setup**: these are development practices,
  supported by the project and run instructions, not additional UI controls.

## UI preservation and validation limits

The source checker compares the new screen/shared-widget/theme files against the
original ZIP and verifies all original UI string/number literals. The supplied
logo and Android assets/configuration are also checked byte-for-byte. This
protects the palette, sizes, spacing, labels and sample content against accidental
redesign during the architecture change.

Stateful wrappers are changed from BLoC builders/listeners to GetX `Obx`/workers;
forms keep local state. Shared UI widgets are otherwise reused, not redesigned.
Pixel-level fidelity and runtime flows still need a Flutter run or golden tests:
Flutter analysis, tests and APK compilation could not run in this workspace.
