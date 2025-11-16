import 'package:flutter/material.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: const Center(child: Text('Explore Feed - Grid of posts')),
    );
  }
}
