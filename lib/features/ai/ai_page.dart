import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'ai_service.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiMessage {
  final bool user;
  final String text;
  const _AiMessage(this.user, this.text);
}

class _AiPageState extends State<AiPage> {
  final prompt = TextEditingController();
  final scroll = ScrollController();
  final messages = <_AiMessage>[];
  bool loading = false;

  @override
  void dispose() {
    prompt.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = prompt.text.trim();
    if (text.isEmpty || loading) return;
    prompt.clear();
    setState(() {
      messages.add(_AiMessage(true, text));
      loading = true;
    });
    try {
      final context = messages
          .take(messages.length > 8 ? 8 : messages.length)
          .map((m) => '${m.user ? 'User' : 'Vault'}: ${m.text}')
          .join('\n');
      final answer = await const AiService().ask(prompt: text, context: context);
      if (mounted) setState(() => messages.add(_AiMessage(false, answer)));
    } catch (e) {
      if (mounted) {
        setState(() => messages.add(_AiMessage(false, 'I could not complete that request. ${e.toString().replaceFirst('Exception: ', '')}')));
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 240), curve: Curves.easeOut);
        });
      }
    }
  }

  void usePrompt(String value) {
    prompt.text = value;
    prompt.selection = TextSelection.collapsed(offset: prompt.text.length);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vault AI', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            const Text('Ask, summarize, connect ideas, and turn your knowledge into action.', style: TextStyle(color: VaultColors.muted)),
            const SizedBox(height: 24),
            if (messages.isEmpty) Expanded(child: _EmptyState(onPrompt: usePrompt))
            else Expanded(
              child: ListView.builder(
                controller: scroll,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: messages.length + (loading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length) return const _ThinkingBubble();
                  final message = messages[index];
                  return Align(
                    alignment: message.user ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 760),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: message.user ? VaultColors.redSoft : VaultColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: message.user ? VaultColors.red.withValues(alpha: .28) : VaultColors.border),
                      ),
                      child: Text(message.text, style: const TextStyle(height: 1.45)),
                    ),
                  );
                },
              ),
            ),
            _Composer(controller: prompt, loading: loading, onSend: send),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ValueChanged<String> onPrompt;
  const _EmptyState({required this.onPrompt});

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 52, height: 52, decoration: BoxDecoration(color: VaultColors.redSoft, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.auto_awesome_rounded, color: VaultColors.red)),
              const SizedBox(height: 18),
              const Text('What can I help you find?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Start with a question about your knowledge, notes, saved content, or ideas.', textAlign: TextAlign.center, style: TextStyle(color: VaultColors.muted)),
              const SizedBox(height: 22),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                _PromptChip(label: 'Summarize my recent notes', onTap: () => onPrompt('Summarize my recent notes.')),
                _PromptChip(label: 'Find connections between my ideas', onTap: () => onPrompt('Find useful connections between my ideas.')),
                _PromptChip(label: 'Turn this into an action plan', onTap: () => onPrompt('Turn my latest saved ideas into an action plan.')),
              ]),
            ],
          ),
        ),
      );
}

class _PromptChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PromptChip({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => ActionChip(label: Text(label), onPressed: onTap);
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();
  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), decoration: BoxDecoration(color: VaultColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: VaultColors.border)), child: const Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5)), SizedBox(width: 10), Text('Vault is thinking…', style: TextStyle(color: VaultColors.muted))])));
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.loading, required this.onSend});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        decoration: BoxDecoration(color: VaultColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: VaultColors.border)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(child: TextField(controller: controller, minLines: 1, maxLines: 5, onSubmitted: (_) => onSend(), decoration: const InputDecoration(hintText: 'Ask Vault anything…', border: InputBorder.none, filled: false))),
          const SizedBox(width: 8),
          IconButton.filled(onPressed: loading ? null : onSend, icon: const Icon(Icons.arrow_upward_rounded), tooltip: 'Send'),
        ]),
      );
}
