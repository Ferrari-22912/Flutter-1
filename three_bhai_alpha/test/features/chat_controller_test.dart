import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/chat_message.dart';
import 'package:three_bhai/repositories/chat_repository.dart';
import 'package:three_bhai/controllers/chat_controller.dart';

class _FailingChat implements ChatRepository {
  @override
  Future<List<ChatMessage>> loadMessages() async => [];
  @override
  Future<ChatMessage> send(String text) async =>
      throw const Failure('Too many messages');
  @override
  Future<void> clear() async {}
}

ChatController _controller(ChatRepository repo) => ChatController(repo);

void main() {
  test('failed send removes the pending bubble and keeps the text', () async {
    final controller = _controller(_FailingChat());
    await controller.load();
    await controller.send('How do I boil eggs?');
    expect(controller.state.messages, isEmpty);
    expect(controller.state.failedText, 'How do I boil eggs?');
    expect(controller.state.errorMessage, 'Too many messages');
    controller.onDelete();
  });

  test('ignores empty and oversized messages', () async {
    final controller = _controller(_FailingChat());
    await controller.load();
    await controller.send('   ');
    await controller.send('x' * 501);
    expect(controller.state.messages, isEmpty);
    expect(controller.state.errorMessage, isNull);
    controller.onDelete();
  });
}
