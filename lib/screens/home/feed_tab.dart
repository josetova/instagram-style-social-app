import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/auth_provider.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      if (userId != null) {
        context.read<FeedProvider>().loadHomeFeed(userId, refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, feedProvider, child) {
          if (feedProvider.isLoading && feedProvider.homeFeed.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthProvider>().userId;
              if (userId != null) {
                await feedProvider.loadHomeFeed(userId, refresh: true);
              }
            },
            child: ListView.builder(
              itemCount: feedProvider.homeFeed.length,
              itemBuilder: (context, index) {
                final post = feedProvider.homeFeed[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: post.userProfilePhoto != null
                              ? NetworkImage(post.userProfilePhoto!)
                              : null,
                          child: post.userProfilePhoto == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(post.username ?? 'Unknown'),
                        subtitle: Text(post.locationName ?? ''),
                      ),
                      if (post.mediaUrls.isNotEmpty)
                        Image.network(
                          post.mediaUrls.first,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    post.isLiked == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: post.isLiked == true
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () {},
                                ),
                                Text('${post.likesCount ?? 0}'),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.comment_outlined),
                                  onPressed: () {},
                                ),
                                Text('${post.commentsCount ?? 0}'),
                              ],
                            ),
                            if (post.caption != null)
                              Text(post.caption!),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
