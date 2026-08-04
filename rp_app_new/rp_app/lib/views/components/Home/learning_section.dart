import 'package:flutter/material.dart';

import '../../../services/course_service.dart';
import '../../video_player_screen.dart';

class TutorialSection extends StatelessWidget {
  const TutorialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// SECTION TITLE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Learn & Tutorials",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),

        SizedBox(height: 16),

        /// TUTORIAL CARDS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              _TutorialCard(
                title: "Purchase Introduction",
                subtitle: "Learn how to buy RP step by step",
                color: Color(0xFF6A11CB),
                courseType: "purchase",
              ),
              SizedBox(height: 12),
              _TutorialCard(
                title: "Selling Tutorial",
                subtitle: "Complete guide to sell RP",
                color: Color(0xFF10B981),
                courseType: "selling",
              ),
              SizedBox(height: 12),
              _TutorialCard(
                title: "Security Tips",
                subtitle: "Keep your account safe",
                color: Color(0xFFF59E0B),
                courseType: "security",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// INTERNAL CARD — SAME UI WITH API INTEGRATION
class _TutorialCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String courseType;

  const _TutorialCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.courseType,
  });

  @override
  State<_TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<_TutorialCard> {
  final CourseService _courseService = CourseService();
  bool _isLoading = false;

  Future<void> _handleCardTap() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch courses by type
      final courses = await _courseService.getCoursesByType(widget.courseType);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (courses.isEmpty) {
        // Show message if no courses found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No videos available for ${widget.title}'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Navigate to video player screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            courses: courses,
            initialIndex: 0,
            categoryTitle: widget.title,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load videos: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleCardTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.2),
                    widget.color.withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    )
                  : Icon(
                      Icons.play_circle_fill_rounded,
                      color: widget.color,
                      size: 28,
                    ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isLoading ? "Loading..." : "Watch Videos",
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.video_library,
                              size: 12,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.courseType.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _isLoading ? Colors.grey.shade300 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
