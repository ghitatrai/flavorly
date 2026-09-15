import 'dart:async';
import 'package:flutter/material.dart';

class CookingTimerWidget extends StatefulWidget {
  const CookingTimerWidget({super.key});

  @override
  State<CookingTimerWidget> createState() => _CookingTimerWidgetState();
}

class _CookingTimerWidgetState extends State<CookingTimerWidget> {
  Timer? _timer;
  int _secondsRemaining = 300; // Default 5 minutes
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _stopTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⏰ Cooking timer finished!')),
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer(int minutes) {
    _stopTimer();
    setState(() => _secondsRemaining = minutes * 60);
  }

  String get _formattedTime {
    final mins = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_outlined, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text('Step Timer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Text(
                _formattedTime,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionChip(label: const Text('5m'), onPressed: () => _resetTimer(5)),
              ActionChip(label: const Text('10m'), onPressed: () => _resetTimer(10)),
              ActionChip(label: const Text('15m'), onPressed: () => _resetTimer(15)),
              ElevatedButton.icon(
                onPressed: _isRunning ? _stopTimer : _startTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? 'Pause' : 'Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}