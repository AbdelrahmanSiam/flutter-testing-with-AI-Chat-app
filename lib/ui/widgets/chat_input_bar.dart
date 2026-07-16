import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_state.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/chat_colors.dart';
import 'custom_text_field.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.hintText = 'Ask anything...',
    required this.messages,
  });

  final TextEditingController? controller;
  final String hintText;
  final List<ChatMessageModel> messages;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }
  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose(); // Only dispose if we created it
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: ChatColors.background,
        border: Border(top: BorderSide(color: ChatColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              hintText: widget.hintText,
            ),
          ),
          const SizedBox(width: 12),
          SendButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              if(context.read<GeminiSendMessageCubit>().state is GeminiSendMessageFailure) {
                widget.messages.removeLast();
              }
              widget.messages.add(ChatMessageModel.user(text));
              controller.clear();
              context.read<GeminiSendMessageCubit>().sendMessage(
                widget.messages,
              );
            },
          ),
        ],
      ),
    );
  }
}
