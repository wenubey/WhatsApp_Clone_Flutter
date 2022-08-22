import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_flutter/common/enums/message_enum.dart';
import 'package:whatsapp_clone_flutter/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone_flutter/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_clone_flutter/models/group.dart';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (senderUser) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: senderUser!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum type,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (senderUser) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: senderUser!,
            messageType: type,
            ref: ref,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
  ) {
    // https://i.giphy.com/media/fn2kee68mheQgMtz1K/200.gif
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData(
          (senderUser) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newGifUrl,
            receiverUserId: receiverUserId,
            senderUser: senderUser!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
