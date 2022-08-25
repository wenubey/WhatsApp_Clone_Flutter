// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:whatsapp_clone_flutter/common/utils/colors.dart';
import 'package:whatsapp_clone_flutter/common/enums/message_enum.dart';
import 'package:whatsapp_clone_flutter/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_flutter/common/utils/utils.dart';
import 'package:whatsapp_clone_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone_flutter/features/chat/widgets/message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;

  const BottomChatField({
    Key? key,
    required this.receiverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.clear();
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum type,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          type,
          widget.isGroupChat,
        );
  }

  void sendGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url!,
            widget.receiverUserId,
            widget.isGroupChat,
          );
    }
  }

  void sendImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void sendVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: IconButton(
                            onPressed: sendGIF,
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 30,
                          child: IconButton(
                            onPressed: sendImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: sendVideo,
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                right: 2.0,
                left: 2.0,
              ),
              child: GestureDetector(
                onTap: sendTextMessage,
                child: CircleAvatar(
                  backgroundColor: chatBottomButtonColor,
                  radius: 25,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  config: Config(
                    buttonMode: ButtonMode.MATERIAL,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                  ),
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
