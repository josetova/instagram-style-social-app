import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/supabase_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      _currentUser = UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error loading user: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String userId,
    String? name,
    String? bio,
    String? customStatus,
    String? profileTheme,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (bio != null) updates['bio'] = bio;
      if (customStatus != null) updates['custom_status'] = customStatus;
      if (profileTheme != null) updates['profile_theme'] = profileTheme;

      await SupabaseService.update('users', userId, updates);
      await loadCurrentUser(userId);
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  Future<bool> followUser(String followerId, String followingId) async {
    try {
      await SupabaseService.insert('follows', {
        'follower_id': followerId,
        'following_id': followingId,
      });
      return true;
    } catch (e) {
      debugPrint('Error following user: $e');
      return false;
    }
  }

  Future<bool> unfollowUser(String followerId, String followingId) async {
    try {
      await SupabaseService.client
          .from('follows')
          .delete()
          .eq('follower_id', followerId)
          .eq('following_id', followingId);
      return true;
    } catch (e) {
      debugPrint('Error unfollowing user: $e');
      return false;
    }
  }
}
