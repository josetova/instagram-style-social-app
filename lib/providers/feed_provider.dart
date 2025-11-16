import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../core/services/supabase_service.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _homeFeed = [];
  List<PostModel> _exploreFeed = [];
  List<PostModel> _localFeed = [];
  bool _isLoading = false;
  int _page = 0;
  static const int _pageSize = 20;

  List<PostModel> get homeFeed => _homeFeed;
  List<PostModel> get exploreFeed => _exploreFeed;
  List<PostModel> get localFeed => _localFeed;
  bool get isLoading => _isLoading;

  Future<void> loadHomeFeed(String userId, {bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _homeFeed.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('posts')
          .select('''
            *,
            users!inner(username, name, profile_photo_url),
            likes(count),
            comments(count)
          ''')
          .eq('is_draft', false)
          .order('created_at', ascending: false)
          .range(_page * _pageSize, (_page + 1) * _pageSize - 1);

      final posts = (response as List).map((json) => PostModel.fromJson(json)).toList();
      _homeFeed.addAll(posts);
      _page++;
    } catch (e) {
      debugPrint('Error loading home feed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadExploreFeed({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _exploreFeed.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('posts')
          .select('''
            *,
            users!inner(username, name, profile_photo_url)
          ''')
          .eq('is_draft', false)
          .eq('visibility', 'public')
          .order('created_at', ascending: false)
          .range(_page * _pageSize, (_page + 1) * _pageSize - 1);

      final posts = (response as List).map((json) => PostModel.fromJson(json)).toList();
      _exploreFeed.addAll(posts);
      _page++;
    } catch (e) {
      debugPrint('Error loading explore feed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLocalFeed(double lat, double lng, double radiusKm) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client.rpc('get_nearby_posts', params: {
        'user_lat': lat,
        'user_lng': lng,
        'radius_km': radiusKm,
      });

      _localFeed = (response as List).map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading local feed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
