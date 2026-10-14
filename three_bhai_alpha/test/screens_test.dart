import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:three_bhai/controllers/auth_controller.dart';
import 'package:three_bhai/controllers/ingredient_selection_controller.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';
import 'package:three_bhai/repositories/mock_ingredient_repository.dart';
import 'package:three_bhai/screens/auth_page.dart';
import 'package:three_bhai/screens/ingredient_selection_page.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());

  // Use built-in fonts here so widget tests never download Google Fonts.
  testWidgets('original demo banner fills login and authenticates',
      (tester) async {
    Get.put(AuthController(MockAuthRepository()));
    var authenticated = false;
    await tester.pumpWidget(GetMaterialApp(
      home: AuthPage(onAuthenticated: () => authenticated = true),
    ));
    final banner = find.textContaining('chef@threebhai.app');
    await tester.ensureVisible(banner);
    await tester.tap(banner);
    await tester.pumpAndSettle();
    final login = find.text('Log in').last;
    await tester.ensureVisible(login);
    await tester.tap(login);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(authenticated, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('original ingredient grid reacts to selection, clear and search',
      (tester) async {
    final controller =
        Get.put(IngredientSelectionController(MockIngredientRepository()));
    controller.load();
    await tester.pumpWidget(GetMaterialApp(
      home: IngredientSelectionPage(
        onGenerate: (_) {},
        onLogout: () {},
        onOpenHistory: () {},
        onOpenChat: () {},
      ),
    ));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    expect(controller.state.selectedCount, 1);
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing selected yet'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'rice');
    await tester.pumpAndSettle();
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('route bindings release their page controller on back',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Scaffold(body: Text('Home'))),
        GetPage(
          name: '/ingredients',
          binding: BindingsBuilder(() {
            Get.put(IngredientSelectionController(MockIngredientRepository())
              ..load());
          }),
          page: () => IngredientSelectionPage(
            onGenerate: (_) {},
            onLogout: () {},
            onOpenHistory: () {},
            onOpenChat: () {},
          ),
        ),
      ],
    ));
    Get.toNamed<void>('/ingredients');
    await tester.pumpAndSettle();
    expect(Get.isRegistered<IngredientSelectionController>(), isTrue);
    final controller = Get.find<IngredientSelectionController>();
    Get.back<void>();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isTrue);
    expect(Get.isRegistered<IngredientSelectionController>(), isFalse);
  });
}
