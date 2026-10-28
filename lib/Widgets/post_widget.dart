
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  late final VideoPlayerController _controller;
  final Key _visibilityKey = UniqueKey();

  final RxBool _isInitialized = false.obs;
  final RxBool _hasError = false.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _hasCompleted = false.obs;

  bool _isVisible = false;
  bool _isDisposed = false;
  bool _isHandlingPlayback = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _controller.addListener(_onVideoUpdate);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();

      if (_isDisposed) return;

      await _controller.setLooping(false);

      if (_isDisposed) return;

      _isInitialized.value = true;
      _isPlaying.value = _controller.value.isPlaying;

      if (_isVisible) {
        await _playVideo(restartIfCompleted: true);
      }
    } catch (e) {
      debugPrint('Feed video error: $e');

      if (!_isDisposed) {
        _hasError.value = true;
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_isDisposed) return;

    final wasVisible = _isVisible;
    _isVisible = info.visibleFraction >= 0.5;

    if (!_isInitialized.value) return;

    if (!_isVisible) {
      _controller.pause();
      return;
    }

    // Sirf newly visible hone par completed video restart karo.
    if (!wasVisible) {
      _playVideo(restartIfCompleted: true);
    } else if (!_hasCompleted.value) {
      _playVideo();
    }
  }

  Future<void> _playVideo({
    bool restartIfCompleted = false,
  }) async {
    if (_isDisposed ||
        !_isInitialized.value ||
        !_isVisible ||
        _isHandlingPlayback) {
      return;
    }

    _isHandlingPlayback = true;

    try {
      if (_hasCompleted.value) {
        if (!restartIfCompleted) return;

        await _controller.seekTo(Duration.zero);

        if (_isDisposed) return;

        _hasCompleted.value = false;
      }

      if (_isDisposed || !_isVisible) return;

      await _controller.play();
      _isPlaying.value = _controller.value.isPlaying;
    } catch (e) {
      debugPrint('Feed video play error: $e');
    } finally {
      _isHandlingPlayback = false;
    }
  }

  Future<void> _togglePlayback() async {
    if (_isDisposed || !_isInitialized.value) return;

    if (_controller.value.isPlaying) {
      await _controller.pause();
      _isPlaying.value = false;
      return;
    }

    if (_hasCompleted.value) {
      await _playVideo(restartIfCompleted: true);
    } else {
      await _playVideo();
    }
  }

  void _onVideoUpdate() {
    if (_isDisposed || !_controller.value.isInitialized) return;

    final value = _controller.value;
    _isPlaying.value = value.isPlaying;

    if (value.duration > Duration.zero &&
        value.position >= value.duration &&
        !value.isPlaying &&
        !_hasCompleted.value) {
      _hasCompleted.value = true;
      _isPlaying.value = false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: _togglePlayback,
        child: Obx(() {
          if (_hasError.value) {
            return const SizedBox(
              height: 250,
              child: Center(
                child: Text('Unable to load video'),
              ),
            );
          }

          return AspectRatio(
            aspectRatio: _isInitialized.value
                ? _controller.value.aspectRatio
                : 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isInitialized.value)
                  SizedBox.expand(
                    child: VideoPlayer(_controller),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                if (_isInitialized.value && !_isPlaying.value)
                  Icon(
                    _hasCompleted.value
                        ? Icons.replay_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 55,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
