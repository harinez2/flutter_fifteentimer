import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsProvider.of(context);
    return Scaffold(
      backgroundColor: settings.themeColor.withOpacity(0.1),
      appBar: AppBar(title: const Text('設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('タイマー時間（分）'),
            Slider(
              value: settings.timerMinutes.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '${settings.timerMinutes}分',
              onChanged: (value) {
                settings.setTimerMinutes(value.round());
              },
            ),
            Text('${settings.timerMinutes}分'),
            const SizedBox(height: 24),
            const Text('テーマカラー'),
            Row(
              children: [
                _colorButton(context, settings, Colors.deepPurple),
                _colorButton(context, settings, Colors.green),
                _colorButton(context, settings, Colors.orange),
                _colorButton(context, settings, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(BuildContext context, AppSettings settings, Color color) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () {
        settings.setThemeColor(color);
      },
    );
  }
} 