import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone_flutter/features/chat/widgets/video_player_item.dart';
import '../../../common/enums/message_enum.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayFile({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 4,
                  left: 4,
                  bottom: 30.0,
                ),
                child: VideoPlayerItem(
                  videoUrl: message,
                ),
              )
            : type == MessageEnum.gif
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CachedNetworkImage(
                      imageUrl: message,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CachedNetworkImage(
                      imageUrl: message,
                    ),
                  );
  }
}
