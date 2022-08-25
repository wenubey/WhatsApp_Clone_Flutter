import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone_flutter/common/enums/message_enum.dart';
import 'package:whatsapp_clone_flutter/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_flutter/common/widgets/loader.dart';
import 'package:whatsapp_clone_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone_flutter/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone_flutter/models/message.dart';
import 'package:whatsapp_clone_flutter/features/chat/widgets/my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;

  const ChatList(
      {required this.receiverUserId, required this.isGroupChat, Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    MessageEnum type,
    bool isMe,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(message, isMe, type),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .groupChatStream(widget.receiverUserId)
            : ref
                .read(chatControllerProvider)
                .chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen &&
                  messageData.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.receiverUserId,
                      messageData.messageId,
                    );
              }
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  repliedMessageType: messageData.repliedMessageType,
                  username: messageData.repliedTo,
                  onLeftSwipe: () => onMessageSwipe(
                    messageData.text,
                    messageData.type,
                    true,
                  ),
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                username: messageData.repliedTo,
                onRightSwipe: () => onMessageSwipe(
                  messageData.text,
                  messageData.repliedMessageType,
                  false,
                ),
                repliedText: messageData.repliedMessage,
                repliedMessageType: messageData.type,
              );
            },
          );
        });
  }
}
