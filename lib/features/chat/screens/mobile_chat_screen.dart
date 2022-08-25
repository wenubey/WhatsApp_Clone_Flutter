import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_flutter/common/utils/colors.dart';
import 'package:whatsapp_clone_flutter/common/widgets/loader.dart';
import 'package:whatsapp_clone_flutter/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone_flutter/models/user_model.dart';
import 'package:whatsapp_clone_flutter/features/chat/widgets/chat_list.dart';

import '../../auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void createCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).createCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return snapshot.data!.isOnline
                      ? Column(
                          children: [
                            Text(name),
                            const Text(
                              'online',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(name),
                          ],
                        );
                },
              ),
        titleSpacing: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => createCall(ref, context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            receiverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
