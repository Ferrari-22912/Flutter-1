import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/core/config/app_config.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';
import 'package:three_bhai/repositories/mock_chat_repository.dart';
import 'package:three_bhai/data/mock_recipe_data_source.dart';
import 'package:three_bhai/repositories/mock_history_repository.dart';
import 'package:three_bhai/repositories/mock_ingredient_repository.dart';

void main() {
  test('alpha build uses mock data by default', () {
    expect(AppConfig.useMockData, isTrue);
  });

  test('demo account needs the right password', () async {
    final auth = MockAuthRepository();
    expect(
      () => auth.signIn(email: AppConfig.demoEmail, password: 'wrong'),
      throwsA(isA<Exception>()),
    );
    final user = await auth.signIn(
      email: AppConfig.demoEmail,
      password: AppConfig.demoPassword,
    );
    expect(user.displayName, 'Ahmed');
  });

  test('seeded history and chat are present after demo login', () async {
    final auth = MockAuthRepository();
    await auth.signIn(
      email: AppConfig.demoEmail,
      password: AppConfig.demoPassword,
    );
    expect((await MockHistoryRepository(auth).getHistory()), isNotEmpty);
    expect((await MockChatRepository(auth).loadMessages()), isNotEmpty);
  });

  test('mock recipe search ranks by matched ingredients', () async {
    final all = await MockIngredientRepository().getIngredients();
    final picked = all
        .where((i) => ['Chicken', 'Rice', 'Onion'].contains(i.name))
        .toList();
    final result = await MockRecipeDataSource().findRecipes(picked);
    expect(result.recipes, isNotEmpty);
    expect(result.recipes.first.title, 'Chicken Biryani');
    expect(result.recipes.first.matchedCount, 3);
  });

  test('chef bhai refuses off-topic questions', () async {
    final auth = MockAuthRepository();
    final reply = await MockChatRepository(auth).send('Who won the election?');
    expect(reply.onTopic, isFalse);
  });
}
