import 'package:get/get.dart';
import 'package:three_bhai/repositories/chat_repository.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/chat_message.dart';

enum ChatStatus { loading, ready, failure }

class ChatState {
  const ChatState({
    this.status = ChatStatus.loading,
    this.messages = const [],
    this.isSending = false,
    this.errorMessage,
    this.failedText,
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final bool isSending;

  /// Shown once as a snackbar, then cleared.
  final String? errorMessage;

  /// The text that failed to send, so the input box can be refilled.
  final String? failedText;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    bool? isSending,
    String? errorMessage,
    String? failedText,
    bool clearError = false,
  }) =>
      ChatState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        failedText: clearError ? null : (failedText ?? this.failedText),
      );
}

class ChatController extends GetxController {
  // Lecture 2: Rx owns state; Obx reads it and rebuilds the UI.
  final observable = const ChatState().obs;
  ChatState get state => observable.value;

  void _updateState(ChatState next) {
    // Lecture 2 lifecycle: never notify a screen after its route is disposed.
    if (!isClosed) observable.value = next;
  }

  ChatController(this._repository);

  final ChatRepository _repository;

  Future<void> load() async {
    _updateState(const ChatState());
    try {
      _updateState(
        ChatState(
          status: ChatStatus.ready,
          messages: await _repository.loadMessages(),
        ),
      );
    } on Failure catch (e) {
      _updateState(
        ChatState(status: ChatStatus.failure, errorMessage: e.message),
      );
    } catch (_) {
      _updateState(
        const ChatState(
          status: ChatStatus.failure,
          errorMessage: 'Could not load your chat.',
        ),
      );
    }
  }

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || text.length > 500 || state.isSending || isClosed)
      return;

    final pending = ChatMessage(
      id: 'pending-${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      text: text,
      createdAt: DateTime.now(),
    );
    _updateState(
      state.copyWith(
        messages: [...state.messages, pending],
        isSending: true,
        clearError: true,
      ),
    );

    try {
      final reply = await _repository.send(text);
      _updateState(
        state.copyWith(messages: [...state.messages, reply], isSending: false),
      );
    } on Failure catch (e) {
      _fail(pending, text, e.message);
    } catch (_) {
      _fail(pending, text, 'Something went wrong. Please try again.');
    }
  }

  void _fail(ChatMessage pending, String text, String message) {
    _updateState(
      state.copyWith(
        messages: state.messages.where((m) => m.id != pending.id).toList(),
        isSending: false,
        errorMessage: message,
        failedText: text,
      ),
    );
  }

  void errorShown() => _updateState(state.copyWith(clearError: true));

  Future<void> clear() async {
    if (state.isSending || isClosed) return;
    final before = state.messages;
    _updateState(state.copyWith(messages: const [], clearError: true));
    try {
      await _repository.clear();
    } catch (_) {
      _updateState(
        state.copyWith(
          messages: before,
          errorMessage: 'Could not clear your chat.',
        ),
      );
    }
  }
}
