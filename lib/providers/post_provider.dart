import 'package:flutter/material.dart';
import 'dart:io';
import '../models/post_model.dart';
import '../core/services/supabase_service.dart';

class PostProvider with ChangeNotifier {
  bool _isUploading = false;

  bool get isUploading => _isUploading;

  Future<bool> createPost({
    required String userId,
    required List<File> mediaFiles,
    required String mediaType,
    String? caption,
    String? locationName,
    double? locationLat,
    double? locationLng,
    List<String>? hashtags,
    bool isDraft = false,
    DateTime? timeLockedUntil,
    String visibility = 'public',
    String? groupId,
  }) async {
    _isUploading = true;
    notifyListeners();

    try {
      // Upload media files
      List<String> mediaUrls = [];
      for (var file in mediaFiles) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final url = await SupabaseService.uploadFile(
          'media',
          'posts/$fileName',
          file.path,
        );
        mediaUrls.add(url);
      }

      // Create post
      await SupabaseService.insert('posts', {
        'user_id': userId,
        'caption': caption,
        'media_urls': mediaUrls,
        'media_type': mediaType,
        'location_name': locationName,
        'hashtags': hashtags ?? [],
        'is_draft': isDraft,
        'time_locked_until': timeLockedUntil?.toIso8601String(),
        'visibility': visibility,
        'group_id': groupId,
      });

      _isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> likePost(String userId, String postId) async {
    try {
      await SupabaseService.insert('likes', {
        'user_id': userId,
        'post_id': postId,
      });
      
      // Update friendship points
      final post = await SupabaseService.client
          .from('posts')
          .select('user_id')
          .eq('id', postId)
          .single();
      
      if (post['user_id'] != userId) {
        await SupabaseService.client.rpc('update_friendship_points', params: {
          'uid1': userId,
          'uid2': post['user_id'],
          'points_to_add': 1,
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('Error liking post: $e');
      return false;
    }
  }

  Future<bool> unlikePost(String userId, String postId) async {
    try {
      await SupabaseService.client
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);
      return true;
    } catch (e) {
      debugPrint('Error unliking post: $e');
      return false;
    }
  }

  Future<bool> savePost(String userId, String postId) async {
    try {
      await SupabaseService.insert('saved_posts', {
        'user_id': userId,
        'post_id': postId,
      });
      return true;
    } catch (e) {
      debugPrint('Error saving post: $e');
      return false;
    }
  }
}
