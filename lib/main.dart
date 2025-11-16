import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/message_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (only if not in demo mode)
  // TODO: Replace with your actual Supabase credentials
  // Get them from: https://supabase.com/dashboard/project/_/settings/api
  try {
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBsYWNlaG9sZGVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDUxOTI4MDAsImV4cCI6MTk2MDc2ODgwMH0.placeholder',
    );
  } catch (e) {
    debugPrint('Supabase initialization failed (Demo Mode): $e');
  }

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('drafts');
  await Hive.openBox('cache');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
