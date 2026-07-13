import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/user_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                children: const [
                  UserMessageBubble(
                    message:
                        'Can you help me understand how machine learning models are trained and what datasets are typically used?',
                    timestamp: '10:24 AM',
                  ),
                  SizedBox(height: 24),
                  AiMessageBubble(
                    intro:
                        'Of course! Here is a clear overview of how ML models are trained:',
                    bodyParagraphs: [
                      'Training starts with collecting and cleaning data. The dataset is split into training, validation, and test sets so the model can learn patterns and be evaluated fairly.',
                      'During training, the model adjusts its internal parameters to minimize prediction error. Common techniques include supervised learning with labeled examples.',
                      'Popular datasets vary by domain — image tasks often use CIFAR-10 or ImageNet, while NLP tasks may use GLUE, SQuAD, or custom corpora.',
                    ],
                    timestamp: '10:25 AM',
                  ),
                  SizedBox(height: 24),
                  UserMessageBubble(
                    message:
                        'That makes sense. What about overfitting and how do we prevent it?',
                    timestamp: '10:26 AM',
                  ),
                  SizedBox(height: 24),
                  AiMessageBubble(
                    intro: 'Great follow-up question.',
                    bodyParagraphs: [
                      'Overfitting happens when a model memorizes training data instead of learning general patterns. You can reduce it with regularization, dropout, early stopping, and more diverse training data.',
                    ],
                    timestamp: '10:26 AM',
                    showRegenerate: false,
                  ),
                  SizedBox(height: 24),
                  UserMessageBubble(
                    message: 'Thanks!',
                    timestamp: '10:27 AM',
                  ),
                ],
              ),
            ),
            const _ChatInputBar(),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: ChatColors.background,
        border: Border(
          top: BorderSide(color: ChatColors.border),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: CustomTextField(
              hintText: 'Ask anything...',
            ),
          ),
          const SizedBox(width: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: ChatColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_upward_rounded,
                color: ChatColors.userBubbleText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
