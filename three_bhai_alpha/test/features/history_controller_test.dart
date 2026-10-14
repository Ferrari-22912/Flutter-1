import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/controllers/history_controller.dart';
import 'package:three_bhai/core/config/app_config.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';
import 'package:three_bhai/repositories/mock_history_repository.dart';
import 'package:three_bhai/repositories/mock_chat_repository.dart';

void main() {
  test('a delayed chat reply stays with the initiating account', () async {
    final auth = MockAuthRepository();
    final chat = MockChatRepository(auth);
    await auth.signIn(
        email: AppConfig.demoEmail, password: AppConfig.demoPassword);
    const prompt = 'How do I cook saffron rice?';
    final pending = chat.send(prompt);
    await auth.signOut();
    await pending;
    expect((await chat.loadMessages()).where((m) => m.text == prompt), isEmpty);
    await auth.signIn(
        email: AppConfig.demoEmail, password: AppConfig.demoPassword);
    expect(
        (await chat.loadMessages()).where((m) => m.text == prompt).length, 1);
  });

  test('history loads, deletes and clears the account records', () async {
    final repository = MockHistoryRepository(MockAuthRepository());
    final controller = HistoryController(repository);
    addTearDown(controller.onDelete);
    await controller.load();
    expect(controller.state.status, HistoryStatus.loaded);
    expect(controller.state.records.length, 4);
    await controller.delete(controller.state.records.first.id);
    expect(controller.state.records.length, 3);
    expect((await repository.getHistory()).length, 3);
    await controller.clear();
    expect(controller.state.records, isEmpty);
    expect(await repository.getHistory(), isEmpty);
  });

  test('history and chat remain isolated between accounts in one session',
      () async {
    final auth = MockAuthRepository();
    final history = MockHistoryRepository(auth);
    final chat = MockChatRepository(auth);
    await auth.signIn(
        email: AppConfig.demoEmail, password: AppConfig.demoPassword);
    await history.clear();
    await chat.clear();
    await auth.signOut();
    await auth.signIn(email: 'other@example.com', password: 'Chef1234');
    expect((await history.getHistory()).length, 4);
    expect(await chat.loadMessages(), isNotEmpty);
    await auth.signOut();
    await auth.signIn(
        email: AppConfig.demoEmail, password: AppConfig.demoPassword);
    expect(await history.getHistory(), isEmpty);
    expect(await chat.loadMessages(), isEmpty);
  });
}
