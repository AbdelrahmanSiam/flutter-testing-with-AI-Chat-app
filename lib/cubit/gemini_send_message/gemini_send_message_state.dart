import 'package:equatable/equatable.dart';

import '../../models/chat_message_model.dart';

abstract class GeminiSendMessageState extends Equatable {
  const GeminiSendMessageState();

  @override
  List<Object?> get props => [];
}

class GeminiSendMessageInitial extends GeminiSendMessageState {
  const GeminiSendMessageInitial();
}

class GeminiSendMessageLoading extends GeminiSendMessageState {
  const GeminiSendMessageLoading();
}

class GeminiSendMessageSuccess extends GeminiSendMessageState {
  const GeminiSendMessageSuccess(this.message);

  final ChatMessageModel message;

  @override
  List<Object?> get props => [message];
}

class GeminiSendMessageFailure extends GeminiSendMessageState {
  const GeminiSendMessageFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
