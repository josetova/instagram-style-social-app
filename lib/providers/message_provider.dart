import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';

class MessageProvider with ChangeNotifier {
  // Placeholder for message functionality
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String> createConversation(List<String> participantIds, {bool emojiOnly = false}) async {
    try {
      final conversation = await SupabaseService.insert('conversations', {
        'is_group': participantIds.length > 2,
        'emoji_only_mode': emojiOnly,
      });

      for (var userId in participantIds) {
        await SupabaseService.insert('conversation_participants', {
          'conversation_id': conversation['id'],
          'user_id': userId,
        });
      }

      return conversation['id'];
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      rethrow;
    }
  }

  Future<bool> sendMessage(String conversationId, String senderId, String content) async {
    try {
      await SupabaseService.insert('messages', {
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
      });
      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }
}
