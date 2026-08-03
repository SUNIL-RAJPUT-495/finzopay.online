import 'package:flutter/material.dart';

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
                videoCount: "3 Videos",
              ),
              SizedBox(height: 12),
              _TutorialCard(
                title: "Selling Tutorial",
                subtitle: "Complete guide to sell RP",
                color: Color(0xFF10B981),
                videoCount: "5 Videos",
              ),
              SizedBox(height: 12),
              _TutorialCard(
                title: "Security Tips",
                subtitle: "Keep your account safe",
                color: Color(0xFFF59E0B),
                videoCount: "2 Videos",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// INTERNAL CARD — SAME UI
class _TutorialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String videoCount;

  const _TutorialCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.videoCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        videoCount,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Watch Video",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
