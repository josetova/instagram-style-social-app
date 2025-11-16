import 'package:flutter/material.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text('Conversations list')),
    );
  }
}
