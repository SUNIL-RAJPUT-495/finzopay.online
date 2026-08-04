import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/course_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<CourseModel> courses;
  final int initialIndex;
  final String categoryTitle;

  const VideoPlayerScreen({
    super.key,
    required this.courses,
    this.initialIndex = 0,
    required this.categoryTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late int _currentIndex;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(
      widget.courses[_currentIndex].videoLink,
    );

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: true,
        ),
      )..addListener(_listener);
    }
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  void _playVideo(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      final videoId = YoutubePlayer.convertUrlToId(
        widget.courses[index].videoLink,
      );
      if (videoId != null) {
        _controller.load(videoId);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // YouTube Player
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              // Auto-play next video if available
              if (_currentIndex < widget.courses.length - 1) {
                _playVideo(_currentIndex + 1);
              }
            },
          ),

          // Current Video Info
          Container(
            width: double.infinity,
            color: Colors.grey.shade900,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courses[_currentIndex].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Video ${_currentIndex + 1} of ${widget.courses.length}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          ),

          // Video Playlist
          Expanded(
            child: Container(
              color: Colors.grey.shade900,
              child: widget.courses.length > 1
                  ? ListView.builder(
                      itemCount: widget.courses.length,
                      itemBuilder: (context, index) {
                        final course = widget.courses[index];
                        final isPlaying = index == _currentIndex;

                        return InkWell(
                          onTap: () => _playVideo(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isPlaying
                                  ? Colors.grey.shade800
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade800,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Play Icon or Number
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isPlaying
                                        ? Colors.red
                                        : Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: isPlaying
                                        ? const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 24,
                                          )
                                        : Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Video Title
                                Expanded(
                                  child: Text(
                                    course.title,
                                    style: TextStyle(
                                      color: isPlaying
                                          ? Colors.white
                                          : Colors.grey.shade300,
                                      fontSize: 15,
                                      fontWeight: isPlaying
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Duration or Status
                                if (isPlaying)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Playing',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No more videos in this playlist',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
