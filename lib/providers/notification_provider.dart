import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';

class NotificationProvider with ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  Future<void> loadUnreadCount(String userId) async {
    try {
      final response = await SupabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      _unreadCount = (response as List).length;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await SupabaseService.update('notifications', notificationId, {'is_read': true});
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }
}
