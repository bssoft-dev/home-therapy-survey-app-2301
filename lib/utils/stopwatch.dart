import 'dart:async';

class StopwatchUtil {
  final Stopwatch _stopwatch = Stopwatch();
  Duration elapsedTime = Duration.zero; // Initialize with zero duration

  // Stream<Duration> get elapsedTimeStream {
  //   return Stream.periodic(
  //       const Duration(milliseconds: 100), (_) => elapsedTime);
  // }

  void startStopwatch() {
    _stopwatch.start();
  }

  void stopStopwatch() {
    _stopwatch.stop();
    elapsedTime = _stopwatch.elapsed;
  }

  void resetStopwatch() {
    _stopwatch.reset();
    elapsedTime = Duration.zero;
  }

  // Optional: Pause/Resume functionality
  void pauseStopwatch() {
    if (_stopwatch.isRunning) {
      elapsedTime += _stopwatch.elapsed;
      _stopwatch.stop();
    }
  }

  void resumeStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
  }
}
