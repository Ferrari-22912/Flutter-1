# 3Bhai — rebuilt using the Flutter lecture slides

The runnable Flutter project is in [`three_bhai_alpha/`](three_bhai_alpha/README.md).
The original PowerPoint files and `three_bhai_alpha_lite.zip` are left unchanged.

The rebuild keeps the supplied app's UI and sample content, and replaces its
BLoC/Cubit and use-case layers with the **GetX, models, repositories, controllers,
and screens** structure taught in the slides.

- [Run and build the app](three_bhai_alpha/README.md)
- [Slide review and implementation mapping](three_bhai_alpha/docs/SLIDE_MAPPING.md)
- [App entry point](three_bhai_alpha/lib/main.dart)
- [App registration and navigation](three_bhai_alpha/lib/app.dart)

Quick start (Flutter SDK and Android tools required):

```sh
cd three_bhai_alpha
flutter create --org com.threebhai --project-name three_bhai --platforms=android .
flutter pub get
flutter analyze
flutter test
flutter run
```

The creation command supplies the generated Android tooling omitted from the lite
ZIP; it does not require `--overwrite`. Use Java 17 for Android builds.

The repository-level workflow `.github/workflows/flutter.yml` runs source checks,
Flutter analysis/tests and builds an APK when triggered on GitHub. It has not been
executed in this workspace: Flutter and Dart SDKs are not installed here.
