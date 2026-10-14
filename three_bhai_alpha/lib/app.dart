import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:three_bhai/controllers/auth_controller.dart';
import 'package:three_bhai/controllers/chat_controller.dart';
import 'package:three_bhai/controllers/history_controller.dart';
import 'package:three_bhai/controllers/ingredient_selection_controller.dart';
import 'package:three_bhai/controllers/recipe_results_controller.dart';
import 'package:three_bhai/core/theme/app_theme.dart';
import 'package:three_bhai/data/mock_recipe_data_source.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/search_record.dart';
import 'package:three_bhai/repositories/auth_repository.dart';
import 'package:three_bhai/repositories/chat_repository.dart';
import 'package:three_bhai/repositories/history_repository.dart';
import 'package:three_bhai/repositories/ingredient_repository.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';
import 'package:three_bhai/repositories/mock_chat_repository.dart';
import 'package:three_bhai/repositories/mock_history_repository.dart';
import 'package:three_bhai/repositories/mock_ingredient_repository.dart';
import 'package:three_bhai/repositories/recipe_repository.dart';
import 'package:three_bhai/repositories/recipe_repository_impl.dart';
import 'package:three_bhai/screens/auth_page.dart';
import 'package:three_bhai/screens/chat_page.dart';
import 'package:three_bhai/screens/history_page.dart';
import 'package:three_bhai/screens/ingredient_selection_page.dart';
import 'package:three_bhai/screens/recipe_results_page.dart';

abstract final class AppRoutes {
  static const auth = '/';
  static const ingredients = '/ingredients';
}

/// Lecture 2: register once with Get.put(), retrieve with Get.find().
/// Repositories/auth live for the app session; page controllers live for a route.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    final auth = Get.put<AuthRepository>(MockAuthRepository(), permanent: true);
    Get.put<IngredientRepository>(MockIngredientRepository(), permanent: true);
    Get.put<HistoryRepository>(MockHistoryRepository(auth), permanent: true);
    Get.put<ChatRepository>(MockChatRepository(auth), permanent: true);
    Get.put<RecipeRepository>(
      RecipeRepositoryImpl(MockRecipeDataSource()),
      permanent: true,
    );
    Get.put(AuthController(auth), permanent: true);
  }
}

class ThreeBhaiApp extends StatelessWidget {
  const ThreeBhaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '3Bhai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      defaultTransition: Transition.native,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.auth,
      // Bindings give every page controller a clear creation/disposal lifetime.
      getPages: [
        GetPage(
          name: AppRoutes.auth,
          page: () => AuthPage(
            onAuthenticated: () => Get.offAllNamed(AppRoutes.ingredients),
          ),
        ),
        GetPage(
          name: AppRoutes.ingredients,
          binding: BindingsBuilder(() {
            Get.put(
              IngredientSelectionController(Get.find<IngredientRepository>())
                ..load(),
            );
          }),
          page: () => IngredientSelectionPage(
            onGenerate: _openLiveResults,
            onOpenHistory: _openHistory,
            onOpenChat: _openChat,
            onLogout: () async {
              await Get.find<AuthController>().signOut();
              Get.offAllNamed(AppRoutes.auth);
            },
          ),
        ),
      ],
    );
  }
}

RecipeResultsController _resultsController() => RecipeResultsController(
      Get.find<RecipeRepository>(),
      Get.find<HistoryRepository>(),
    );

void _openLiveResults(List<Ingredient> ingredients) {
  Get.to<void>(
    () => RecipeResultsPage(
      labels: [for (final i in ingredients) '${i.emoji} ${i.name}'],
    ),
    binding: BindingsBuilder(() {
      Get.put(_resultsController()..search(ingredients));
    }),
  );
}

void _openSaved(SearchRecord record) {
  Get.to<void>(
    () => RecipeResultsPage(labels: record.ingredients, canSearchAgain: false),
    binding: BindingsBuilder(() {
      Get.put(_resultsController()..showSaved(record));
    }),
  );
}

void _openHistory() {
  Get.to<void>(
    () => const HistoryPage(onOpen: _openSaved),
    binding: BindingsBuilder(() {
      Get.put(HistoryController(Get.find<HistoryRepository>())..load());
    }),
  );
}

void _openChat() {
  Get.to<void>(
    () => const ChatPage(),
    binding: BindingsBuilder(() {
      Get.put(ChatController(Get.find<ChatRepository>())..load());
    }),
  );
}
