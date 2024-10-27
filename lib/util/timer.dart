import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeProvider extends ChangeNotifier {

  /// The Timer.
  Timer? _timer;

  /// The current time.
  DateTime _currentTime;

  /// Fixed duration for the timer interval
  static const Duration _interval = Duration(seconds: 1);

  // Constructor that accepts a start time
  TimeProvider(DateTime startTime) : _currentTime = startTime {
    _startTimer();
  }

  /// Getter method for a formatted time.
  String get formattedTime => DateFormat('hh:mm:ss a').format(_currentTime); // Format the time

  /// Starts the Timer.
  void _startTimer() {
    _timer = Timer.periodic(_interval, (timer) {
      _currentTime = _currentTime.add(_interval); // Increment the time by the interval
      notifyListeners(); // Notify listeners to rebuild widgets
    });
  }

  /// Changes the start time and resets the Timer.
  void changeStartTime(DateTime newStartTime) {
    _currentTime = newStartTime;
    _timer?.cancel();
    _startTimer();

    // Notify listeners to update the UI
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
