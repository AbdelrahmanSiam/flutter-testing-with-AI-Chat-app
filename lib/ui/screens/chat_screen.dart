import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/chat_bot_app_bar.dart';
import '../widgets/chat_bot_app_bar_action.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/user_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.background,
      appBar: const ChatBotAppBar(
        title: 'Chat Bot',
        subtitle: 'Always here to help',
        leading: ChatBotAppBarAction(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back',
        ),
        actions: [
          ChatBotAppBarAction(
            icon: Icons.volume_up_outlined,
            tooltip: 'Speaker',
          ),
          ChatBotAppBarAction(
            icon: Icons.upload_outlined,
            tooltip: 'Upload',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                children: const [
                  UserMessageBubble(
                    message:
                        'Can you help me understand how machine learning models are trained ?',
                    timestamp: '10:24 AM',
                  ),
                  SizedBox(height: 24),
                  AiMessageBubble(
                    intro:
                        'Of course! Here is a clear overview of how ML models are trained:',
                    bodyParagraphs: [
                      'Training starts with collecting and cleaning data. ',
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
                      'Overfitting happens when a model memorizes training data instead of learning general patterns.',
                    ],
                    timestamp: '10:26 AM',
                    showRegenerate: false,
                  ),
                  SizedBox(height: 24),
                  UserMessageBubble(message: 'Thanks!', timestamp: '10:27 AM'),
                ],
              ),
            ),
          const ChatInputBar(),
        ],
      ),
    );
  }
}
