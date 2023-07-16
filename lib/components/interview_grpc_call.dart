import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:interview_grpc_gen/interview_grpc_gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';

final channelProvider = Provider.autoDispose<ClientChannel>((ref) {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  ref.onDispose(() {
    channel.shutdown();
  });
  return channel;
});
