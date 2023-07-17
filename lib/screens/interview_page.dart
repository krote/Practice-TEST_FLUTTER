import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_flutter/components/interview_grpc_call.dart';

class InterviewPage extends HookWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Hello, world')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final interview =
                    ref.watch(interviewProvider).valueOrNull ?? '';
                return Text(interview);
              },
            ),
            const SizedBox(height: 32),
            Consumer(
              builder: (context, ref, child) {
                return TextFormField(
                  controller: textController,
                  onEditingComplete: () {
                    ref
                        .read(nameProvider.notifier)
                        .update((state) => textController.text);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
