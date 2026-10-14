import 'package:three_bhai/repositories/auth_repository.dart';
import 'package:three_bhai/models/chat_message.dart';
import 'package:three_bhai/repositories/chat_repository.dart';

/// ALPHA: Chef Bhai with canned answers and a pre-filled chat history.
/// No network or AI. Replies are picked by simple keyword matching and
/// off-topic questions get the polite "cooking only" refusal.
class MockChatRepository implements ChatRepository {
  MockChatRepository(this._auth);

  final AuthRepository _auth;
  final Map<String, List<ChatMessage>> _store = {};

  String get _uid => _auth.currentUser?.id ?? 'signed_out';

  List<ChatMessage> get _mine => _store.putIfAbsent(_uid, _seed);

  List<ChatMessage> _seed() {
    final t = DateTime.now().subtract(const Duration(days: 1, hours: 1));
    ChatMessage m(int i, ChatRole role, String text, {bool onTopic = true}) =>
        ChatMessage(
          id: 'seed-$i',
          role: role,
          text: text,
          createdAt: t.add(Duration(minutes: i * 2)),
          onTopic: onTopic,
        );
    return [
      m(0, ChatRole.user, 'What can I cook with eggs and rice?'),
      m(
        1,
        ChatRole.assistant,
        'Egg fried rice is perfect for that! Use cold, day-old rice, scramble '
        'the eggs first, then toss everything with garlic, soy sauce and a '
        'pinch of black pepper. Ready in 10 minutes.',
      ),
      m(2, ChatRole.user, 'Substitute for butter in baking?'),
      m(
        3,
        ChatRole.assistant,
        'You can swap butter 1:1 with ghee or margarine. For a lighter bake, '
        'use 3/4 the amount of oil, or replace half the butter with mashed '
        'banana or yogurt.',
      ),
      m(4, ChatRole.user, 'Who won the cricket match yesterday?'),
      m(
        5,
        ChatRole.assistant,
        'I am Chef Bhai, so I can only help with cooking, ingredients and '
        'food storage. Ask me anything about the kitchen!',
        onTopic: false,
      ),
      m(6, ChatRole.user, 'How long do I boil eggs?'),
      m(
        7,
        ChatRole.assistant,
        'Lower eggs into boiling water: 6 minutes for soft, 9 minutes for '
        'jammy and 12 minutes for fully hard-boiled. Cool them in ice water '
        'so they peel easily.',
      ),
    ];
  }

  static const _offTopic =
      'I am Chef Bhai, so I can only help with cooking, ingredients and food '
      'storage. Ask me anything about the kitchen!';

  static const _rules = <(List<String>, String)>[
    (
      ['boil'],
      'Lower eggs into boiling water: 6 minutes for soft, 9 for jammy and 12 '
          'for hard-boiled. Cool them in ice water so they peel easily.',
    ),
    (
      ['store', 'storage', 'fridge', 'leftover', 'keep'],
      'Cool cooked food within 2 hours, store it in airtight containers and '
          'keep it in the fridge for up to 3 to 4 days. Reheat until steaming hot.',
    ),
    (
      ['substitute', 'replace', 'instead of', 'swap'],
      'Tell me the ingredient and I will suggest a swap. Common ones: yogurt '
          'for cream, honey for sugar, ghee for butter, lemon juice for vinegar.',
    ),
    (
      ['chicken'],
      'Chicken is cooked safely at 74 C (165 F) inside. Marinate in yogurt and '
          'spices for 30 minutes for juicy results. Karahi, biryani and a lemon '
          'garlic roast are great options.',
    ),
    (
      ['rice'],
      'Rinse rice until the water runs clear, then use 1 part rice to 2 parts '
          'water (1.5 for basmati). Simmer covered on low for 15 minutes and '
          'rest for 5.',
    ),
    (
      ['pasta', 'noodle'],
      'Use plenty of well-salted water and cook until al dente. Save a cup of '
          'the pasta water to loosen your sauce and help it cling.',
    ),
    (
      ['cook', 'recipe', 'dinner', 'lunch', 'breakfast'],
      'Pick what you have on the Ingredients screen and tap Generate, and '
          'I will rank recipes by how many of your ingredients they use. '
          'Tell me what you have and I can suggest an idea here too!',
    ),
    (
      [
        'salt',
        'spice',
        'masala',
        'curry',
        'sauce',
        'onion',
        'tomato',
        'potato',
      ],
      'For a rich base, cook onions until golden before adding tomato and '
          'spices, and let the oil separate from the masala. That is the '
          'secret of deep flavour.',
    ),
  ];

  String _reply(String text) {
    final q = text.toLowerCase();
    for (final (keys, answer) in _rules) {
      if (keys.any(q.contains)) return answer;
    }
    return _offTopic;
  }

  @override
  Future<List<ChatMessage>> loadMessages() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List.of(_mine);
  }

  @override
  Future<ChatMessage> send(String text) async {
    // Capture the initiating account before waiting (Lecture 3: user isolation).
    final messages = _mine;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final now = DateTime.now();
    final answer = _reply(text);
    final reply = ChatMessage(
      id: 'a${now.microsecondsSinceEpoch}',
      role: ChatRole.assistant,
      text: answer,
      createdAt: now.add(const Duration(milliseconds: 1)),
      onTopic: answer != _offTopic,
    );
    messages
      ..add(
        ChatMessage(
          id: 'u${now.microsecondsSinceEpoch}',
          role: ChatRole.user,
          text: text,
          createdAt: now,
        ),
      )
      ..add(reply);
    return reply;
  }

  @override
  Future<void> clear() async => _mine.clear();
}
