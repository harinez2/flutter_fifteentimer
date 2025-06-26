import 'package:flutter/material.dart';
import '../main.dart';
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _choices = ['勉強', '仕事', '運動', '家事'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChoicePressed(String choice) {
    setState(() {
      _controller.text = choice;
    });
  }

  void _startTimer() {
    final settings = AppSettingsProvider.of(context);
    settings.startTimer(_controller.text);
  }

  void _pauseTimer() {
    final settings = AppSettingsProvider.of(context);
    settings.pauseTimer();
  }

  void _resetTimer() {
    final settings = AppSettingsProvider.of(context);
    settings.resetTimer();
  }

  void _completeTimer() {
    final settings = AppSettingsProvider.of(context);
    settings.completeTimer();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsProvider.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double circleSize = screenWidth * 0.95;
    double progress = settings.totalSeconds == 0 ? 0 : 1 - settings.remainingSeconds / settings.totalSeconds;
    final timerText = settings.formatTime(settings.isRunning ? settings.remainingSeconds : settings.timerMinutes * 60);
    final timerMinutes = settings.timerMinutes;
    return Scaffold(
      appBar: AppBar(title: const Text('15分タイマー'), backgroundColor: settings.themeColor),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'やることを入力してください',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _choices.map((choice) => ElevatedButton(
                onPressed: () => _onChoicePressed(choice),
                child: Text(choice),
              )).toList(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: circleSize,
                  width: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: settings.isRunning ? progress : 0,
                        strokeWidth: 36,
                        backgroundColor: settings.themeColor.withOpacity(0.15),
                        color: settings.themeColor,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timerText,
                            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                          ),
                          Text('$timerMinutes分', style: const TextStyle(fontSize: 32)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (settings.isRunning) ...[
                  IconButton(
                    icon: Icon(settings.isPaused ? Icons.play_arrow : Icons.pause),
                    iconSize: 56,
                    onPressed: _pauseTimer,
                    tooltip: settings.isPaused ? '再開' : '一時停止',
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 56,
                    onPressed: _resetTimer,
                    tooltip: 'リセット',
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.grey[710]),
                    iconSize: 64,
                    onPressed: _completeTimer,
                    tooltip: '完了',
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      textStyle: const TextStyle(fontSize: 32),
                    ),
                    child: const Text('開始'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
} 