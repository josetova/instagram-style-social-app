import 'package:flutter/material.dart';

class LocalFeedTab extends StatelessWidget {
  const LocalFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Feed (1-3km)')),
      body: const Center(child: Text('Posts near you')),
    );
  }
}
