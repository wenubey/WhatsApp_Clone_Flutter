import 'package:audioplayers/audioplayers.dart';
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
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
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
            : type == MessageEnum.audio
                ? StatefulBuilder(
                    builder: (context, setState) {
                      return IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                        ),
                      );
                    },
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
