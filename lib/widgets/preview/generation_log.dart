import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/generation_state.dart';

/// A terminal-style scrollable log that shows generation progress messages.
class GenerationLog extends StatefulWidget {
  const GenerationLog({super.key});

  @override
  State<GenerationLog> createState() => _GenerationLogState();
}

class _GenerationLogState extends State<GenerationLog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final generationState = context.watch<GenerationState>();
    final logMessages = generationState.logMessages;
    final theme = Theme.of(context);

    // Auto-scroll whenever messages change.
    _scrollToBottom();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF8B0000).withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F1A),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF8B0000).withAlpha(40),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal,
                  size: 14,
                  color: Color(0xFF4CAF50),
                ),
                const SizedBox(width: 8),
                Text(
                  'Generation Log',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  '${logMessages.length} entries',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ),
          // Log entries
          Expanded(
            child: logMessages.isEmpty
                ? Center(
                    child: Text(
                      'No log entries yet.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF404040),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: logMessages.length,
                    itemBuilder: (context, index) {
                      final message = logMessages[index];
                      final isError = message.contains('failed') ||
                          message.contains('Error');
                      final isComplete = message.contains('complete');

                      Color textColor;
                      if (isError) {
                        textColor = const Color(0xFFE94560);
                      } else if (isComplete) {
                        textColor = const Color(0xFF4CAF50);
                      } else {
                        textColor = const Color(0xFF00BCD4);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: textColor,
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
