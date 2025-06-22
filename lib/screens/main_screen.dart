import 'package:flutter/material.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _choices = ['勉強', '運動', '休憩'];
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  void _onChoicePressed(String choice) {
    setState(() {
      _controller.text = choice;
    });
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = 15 * 60;
      _isRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
        // TODO: 通知や結果入力処理
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('15分タイマー')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('やることを入力'),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'やることを入力してください',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _choices.map((choice) => ElevatedButton(
                onPressed: () => _onChoicePressed(choice),
                child: Text(choice),
              )).toList(),
            ),
            const SizedBox(height: 32),
            if (_isRunning)
              Column(
                children: [
                  const Text('残り時間', style: TextStyle(fontSize: 18)),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: _controller.text.isNotEmpty ? _startTimer : null,
                child: const Text('開始'),
              ),
          ],
        ),
      ),
    );
  }
} 