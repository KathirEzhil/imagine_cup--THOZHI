import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CommunityBlogScreen extends StatefulWidget {
  const CommunityBlogScreen({super.key});
  
  @override
  State<CommunityBlogScreen> createState() => _CommunityBlogScreenState();
}

class _CommunityBlogScreenState extends State<CommunityBlogScreen> {
  final List<BlogPost> _posts = [
    BlogPost(
      title: 'Understanding Burnout in Homemakers',
      excerpt: 'Learn about the signs and symptoms of burnout, and how to recognize them early...',
      category: 'Mental Health',
      readTime: '5 min read',
    ),
    BlogPost(
      title: 'The Importance of Self-Care',
      excerpt: 'Self-care is not selfish. Discover why taking time for yourself is essential...',
      category: 'Self-Care',
      readTime: '3 min read',
    ),
    BlogPost(
      title: 'Building a Support Network',
      excerpt: 'Learn how to build and maintain a support network as a homemaker...',
      category: 'Community',
      readTime: '4 min read',
    ),
    BlogPost(
      title: 'Simple Mindfulness Practices',
      excerpt: 'Easy mindfulness exercises you can do in just a few minutes each day...',
      category: 'Wellness',
      readTime: '2 min read',
    ),
    BlogPost(
      title: 'Managing Daily Stress',
      excerpt: 'Practical tips for managing stress in your daily routine...',
      category: 'Stress Management',
      readTime: '6 min read',
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Community & Blog',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Articles & Resources',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mental health articles and homemaker-focused content',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 24),
              // Blog posts
              ..._posts.map((post) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildBlogCard(post),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBlogCard(BlogPost post) {
    return Card(
      child: InkWell(
        onTap: () {
          _showBlogPost(post);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      post.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    post.readTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.excerpt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showBlogPost(post);
                    },
                    child: const Text('Read More'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showBlogPost(BlogPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.readTime,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                post.excerpt,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This is a sample blog post. In the full version, this would contain the complete article content. The app provides read-only content focused on mental health and homemaker well-being.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogPost {
  final String title;
  final String excerpt;
  final String category;
  final String readTime;
  
  BlogPost({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.readTime,
  });
}
