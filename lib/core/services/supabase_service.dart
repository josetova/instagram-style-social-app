import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Auth
  static Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // Database queries
  static Future<List<Map<String, dynamic>>> query(String table) async {
    return await client.from(table).select();
  }

  static Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await client.from(table).insert(data).select().single();
  }

  static Future<void> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    await client.from(table).update(data).eq('id', id);
  }

  static Future<void> delete(String table, String id) async {
    await client.from(table).delete().eq('id', id);
  }

  // Storage
  static Future<String> uploadFile(
    String bucket,
    String path,
    String filePath,
  ) async {
    await client.storage.from(bucket).upload(path, filePath);
    return client.storage.from(bucket).getPublicUrl(path);
  }

  // Real-time subscriptions
  static RealtimeChannel subscribe(
    String table,
    void Function(PostgresChangePayload) callback,
  ) {
    return client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }
}
