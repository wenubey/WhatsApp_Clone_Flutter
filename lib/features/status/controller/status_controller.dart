import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone_flutter/features/status/repository/status_repository.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);
    return StatusController(statusRepository: statusRepository, ref: ref);
  },
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData(
      (user) {
        statusRepository.uploadStatus(
          userName: user!.name,
          profilePic: user.profilePic,
          phoneNumber: user.phoneNumber,
          statusImage: file,
          context: context,
        );
      },
    );
  }
}
