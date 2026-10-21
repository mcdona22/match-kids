import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_test_body.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class SpellingTestScreen extends HookConsumerWidget with UiLoggy {
  const SpellingTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingWords = useState(false);
    final hideWords = useState(false);

    final sessionWords = ref.watch(spellingWordsProvider).words;
    loggy.debug('build: session words: $sessionWords');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spelling Test'),
        actions: const [ToggleThemModeButton()],
      ),
      body: SpellingTestBody(
        hideWords: hideWords.value,
        isEditing: isEditingWords.value,
        onToggleEditor: () => isEditingWords.value = !isEditingWords.value,
      ),
    );
  }
}
