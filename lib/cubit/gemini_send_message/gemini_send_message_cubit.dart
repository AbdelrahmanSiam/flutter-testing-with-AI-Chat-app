import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_message_model.dart';
import '../../data/repositories/gemini_send_message_repository.dart';
import 'gemini_send_message_state.dart';

class GeminiSendMessageCubit extends Cubit<GeminiSendMessageState> {
  GeminiSendMessageCubit({required GeminiSendMessageRepository repository})
      : _repository = repository,
        super(const GeminiSendMessageInitial());

  final GeminiSendMessageRepository _repository;

  Future<void> sendMessage(List<ChatMessageModel> messages) async {
    emit(const GeminiSendMessageLoading());

    try {
      final response = await _repository.geminiSendMessage(messages);
      emit(GeminiSendMessageSuccess(response));
    } catch (error) {
      emit(GeminiSendMessageFailure(error.toString()));
    }
  }
}
