




import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FeedVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FeedVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {

  late VideoPlayerController _controller;
  bool _isDisposed = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _initializeVideo();
  }


  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();

      if (!mounted || _isDisposed) return;
      await _controller.setLooping(true);

      if (!mounted || _isDisposed) return;
      await _controller.play();

      if (!mounted || _isDisposed) return;
      setState(() {});
    } catch (e) {
      debugPrint('Feed video error: $e');

      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }


  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text('Unable to load video'),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        setState(() {});
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}