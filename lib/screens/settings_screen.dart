import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('タイマー時間（分）'),
            Slider(
              value: 15,
              min: 5,
              max: 60,
              divisions: 11,
              label: '15',
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            const Text('テーマカラー'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.deepPurple),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.green),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.orange),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 