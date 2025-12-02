part of '../../ui.dart';

class VideoApp extends StatefulWidget {
  final RPInstructionStep step;
  const VideoApp({super.key, required this.step});

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isCompleted = false;
  bool _hasError = false;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.step.videoPath != null &&
          widget.step.videoPath!.startsWith("http")) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.step.videoPath!))
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized
                setState(() {
                  _duration = _controller.value.duration;
                });
              }).catchError((onError) {
                _showConnectionErrorDialog();
              });
      } else {
        print("widget.step.videopath ${widget.step.videoPath}");
        _controller = VideoPlayerController.asset(widget.step.videoPath!)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized
            setState(() {
              _duration = _controller.value.duration;
            });
          }).catchError((onError) {
            _showConnectionErrorDialog();
          });
      }
    } catch (e) {
      debugPrint("Initialization Error: $e");
    }

    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
        _position = _controller.value.position;
        if (_controller.value.position == _controller.value.duration) {
          _isPlaying = false;
          _isCompleted = true;
        }
      });

      // Check for errors during playback
      if (_controller.value.hasError) {
        setState(() {
          _hasError = true;
        });
        _showConnectionErrorDialog();
      }
    });
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isCompleted) {
      // If video completed, restart it from the beginning
      _controller.seekTo(Duration.zero);
      _controller.play();
      setState(() {
        _isPlaying = true;
        _isCompleted = false;
      });
    } else if (_isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _seekToPosition(double value) {
    final position = Duration(seconds: value.round());
    _controller.seekTo(position);
  }

  // Method to show the error dialog when video loading fails
  void _showConnectionErrorDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text('Connection Error'),
          ),
          titlePadding: const EdgeInsets.symmetric(vertical: 12.0),
          insetPadding:
              const EdgeInsets.symmetric(vertical: 24.0, horizontal: 40),
          content: const Text(
              'Internet connection not found or video could not be loaded.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                // Retry loading the video
                setState(() {
                  _controller.initialize();
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFullScreen() {
    Navigator.of(context).push(MaterialPageRoute<dynamic>(
      builder: (context) => FullscreenVideoPlayer(
        controller: _controller,
        onExitFullScreen: () {
          Navigator.of(context).pop();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Video Player
        GestureDetector(
          onTap: _togglePlayPause, // Play/Pause on tap
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      if (!_isPlaying && !_isCompleted)
                        const Icon(
                          Icons.play_circle_outline,
                          size: 64.0,
                          color: Colors.white,
                        ),
                      if (_isCompleted)
                        const Icon(
                          Icons.replay,
                          size: 64.0,
                          color: Colors.white,
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_controller.value.isInitialized && !_hasError)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      overlayShape:
                                          SliderComponentShape.noOverlay),
                                  child: Slider(
                                    min: 0.0,
                                    max: _duration?.inSeconds.toDouble() ?? 1.0,
                                    value:
                                        _position?.inSeconds.toDouble() ?? 0.0,
                                    onChanged: (value) {
                                      _seekToPosition(value);
                                    },
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                  onPressed: _toggleFullScreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: const CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class FullscreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onExitFullScreen;

  const FullscreenVideoPlayer(
      {super.key, required this.controller, required this.onExitFullScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              },
              child: controller.value.isInitialized
                  ? SizedBox.expand(
                      // Fill the available space and scale the video to cover
                      // (this will crop the video if its aspect ratio doesn't
                      // match the device's aspect ratio).
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: SizedBox(
                          // Use the video's intrinsic size when available,
                          // otherwise fall back to the screen size.
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Slider(
                      min: 0.0,
                      max: controller.value.duration.inSeconds.toDouble(),
                      value: controller.value.position.inSeconds.toDouble(),
                      onChanged: (value) {
                        controller.seekTo(Duration(seconds: value.round()));
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                        ),
                        onPressed: onExitFullScreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
