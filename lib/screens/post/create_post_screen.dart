import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Post', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: const Center(child: Text('Create post interface')),
    );
  }
}
