import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('Username', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Bio goes here'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
