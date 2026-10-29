
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../Controllers/mystory_controller.dart';
import '../Models/storyModel.dart';
import '../Utils/appThemeStyle.dart';

class StoryScreen extends StatefulWidget {
  final String storyImage;
  final String storyName;
  final String storyAvatar;
  final List<StoryItem> stories;

  const StoryScreen({
    super.key,
    required this.storyImage,
    required this.storyName,
    required this.storyAvatar,
    required this.stories,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Timer? storyTimer;
  VideoPlayerController? videoController;
  bool videoReady = false;
  bool isPaused = false;
  bool isLoadingVideo = false;
  late AnimationController progressController;

  StoryItem get currentStory => widget.stories[currentIndex];
  bool isViewersSheetOpen = false;
  bool isCompletingStories = false;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    if (widget.stories.isNotEmpty) {
      showStory(0);
    }
  }

  void showStory(int index) {
    if (index >= widget.stories.length) {
      completeStoriesAndClose();
      return;
    }

    if (index < 0) return;

    storyTimer?.cancel();
    videoController?.dispose();
    videoController = null;

    progressController.stop();
    progressController.reset();

    setState(() {
      currentIndex = index;
      videoReady = false;
      isPaused = false;
      isLoadingVideo = currentStory.type.toLowerCase() == 'video';
    });

    final controller = Get.find<MyStoryController>();

    controller.storyViewers.value = null;

    if (currentStory.isMine) {
      controller.fetchStoryViewers(currentStory.id);
    }

    if (currentStory.type.toLowerCase() == 'video') {
      playVideoStory(currentStory.mediaUrl);
    } else {
      progressController.duration = const Duration(seconds: 5);
      progressController.forward();
      storyTimer = Timer(const Duration(seconds: 5), nextStory);
    }
  }

  Future<void> completeStoriesAndClose() async {
    if (isCompletingStories) return;

    isCompletingStories = true;

    try {
      final controller = Get.find<MyStoryController>();

      for (final story in widget.stories) {
        if (!story.isSeen) {
          await controller.storySeen(story.id);
        }
      }
    } finally {
      if (mounted) {
        Get.back();
      }
    }
  }

  Future<void> playVideoStory(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      videoController = controller;

      await controller.initialize();

      if (!mounted || videoController != controller) {
        await controller.dispose();
        return;
      }

      controller.addListener(onVideoUpdate);

      setState(() {
        videoReady = true;
        isLoadingVideo = false;
      });

      await controller.play();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingVideo = false;
      });

      // If the video cannot load, move to the next story.
      storyTimer?.cancel();
      storyTimer = Timer(const Duration(seconds: 3), nextStory);
    }
  }

  void onVideoUpdate() {
    final controller = videoController;

    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.position >= controller.value.duration &&
        !controller.value.isPlaying) {
      nextStory();
    }
  }

  void nextStory() {
    if (!mounted) return;
    showStory(currentIndex + 1);
  }

  void previousStory() {
    if (!mounted) return;

    if (currentIndex > 0) {
      showStory(currentIndex - 1);
    } else {
      showStory(0);
    }
  }

  Future<void> openStoryViewers() async {
    if (!currentStory.isMine || isViewersSheetOpen) return;

    final controller = Get.find<MyStoryController>();

    isViewersSheetOpen = true;

    final wasPaused = isPaused;

    if (!wasPaused) {
      togglePause();
    }

    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.45,
            minChildSize: 0.30,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Obx(() {
                final result = controller.storyViewers.value;
                final data = result?.data;
                final viewers = data?.items ?? [];

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Story viewers',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${data?.viewsCount ?? 0} views',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: controller.isLoadingViewers.value
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : viewers.isEmpty
                          ? const Center(
                        child: Text(
                          'No viewers yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      )
                          : ListView.builder(
                        controller: scrollController,
                        itemCount: viewers.length,
                        itemBuilder: (context, index) {
                          final viewer = viewers[index];

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor:
                              Colors.grey.shade200,
                              backgroundImage:
                              viewer.avatarUrl != null &&
                                  viewer.avatarUrl!
                                      .isNotEmpty
                                  ? NetworkImage(
                                viewer.avatarUrl!,
                              )
                                  : null,
                              child: viewer.avatarUrl == null ||
                                  viewer.avatarUrl!.isEmpty
                                  ? const Icon(
                                Icons.person,
                                color: Colors.grey,
                              )
                                  : null,
                            ),
                            title: Text(
                              viewer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (viewer.category != null &&
                                    viewer.category!.isNotEmpty)
                                  viewer.category!,
                                if (viewer.city != null &&
                                    viewer.city!.isNotEmpty)
                                  viewer.city!,
                              ].join(' • '),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
            },
          );
        },
      );
    } finally {
      isViewersSheetOpen = false;

      if (mounted && !wasPaused) {
        togglePause();
      }
    }
  }

  void handleStorySwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -200 && currentStory.isMine) {
      openStoryViewers();
    }
  }


  void togglePause() {
    if (currentStory.type.toLowerCase() == 'video') {
      final controller = videoController;
      if (controller == null || !controller.value.isInitialized) return;

      if (controller.value.isPlaying) {
        controller.pause();
        setState(() => isPaused = true);
      } else {
        controller.play();
        setState(() => isPaused = false);
      }
    } else {
      if (isPaused) {
        progressController.forward();
        storyTimer = Timer(
          progressController.duration! * (1 - progressController.value),
          nextStory,
        );
      } else {
        storyTimer?.cancel();
        progressController.stop();
      }

      setState(() => isPaused = !isPaused);
    }
  }

  @override
  void dispose() {
    storyTimer?.cancel();
    videoController?.removeListener(onVideoUpdate);
    videoController?.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No stories available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final story = currentStory;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: handleStorySwipe,

        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: story.type.toLowerCase() == 'video'
                    ? (videoReady && videoController != null
                    ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoController!.value.size.width,
                    height: videoController!.value.size.height,
                    child: VideoPlayer(videoController!),
                  ),
                )
                    : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ))
                    : Image.network(
                  story.mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/profileimg.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Container(color: Colors.black.withOpacity(0.15)),

              // Progress bars for all stories
              Positioned(
                top: 1.h,
                left: 2.w,
                right: 2.w,
                child: Row(
                  children: List.generate(widget.stories.length, (index) {
                    return Expanded(
                      child: Container(
                        height: 0.4.h,
                        margin: EdgeInsets.symmetric(horizontal: 0.4.w),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedBuilder(
                            animation: progressController,
                            builder: (_, __) {
                              double value = 0;

                              if (index < currentIndex) {
                                value = 1;
                              } else if (index == currentIndex) {
                                value = progressController.value;
                              }

                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.transparent,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // User information
              Positioned(
                top: 3.5.h,
                left: 3.w,
                right: 3.w,
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.storyAvatar,
                        width: 10.w,
                        height: 10.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/profileimg.webp',
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '${widget.storyName} ${story.timeAgo}',
                        style: Appthemestyle.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Tap left for previous; right for next
              Positioned.fill(
                top: 12.h,
                bottom: 10.h,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: previousStory,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: nextStory,
                      ),
                    ),
                  ],
                ),
              ),

          if (currentStory.isMine)
      Positioned(
      bottom: 1.h,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: openStoryViewers,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(height: 3),
            const Text(
              'Swipe up to see viewers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final data = Get.find<MyStoryController>()
                  .storyViewers.value?.data;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${data?.viewsCount ?? 0} views',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    ),

    // Caption
              // if (story.caption.isNotEmpty)
              //   Positioned(
              //     left: 4.w,
              //     right: 4.w,
              //     bottom: 8.h,
              //     child: Text(
              //       story.caption,
              //       style: Appthemestyle.poppins(
              //         color: Colors.white,
              //         fontSize: 14.sp,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
