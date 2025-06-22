import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('履歴')),
      body: ListView.builder(
        itemCount: 10, // 仮のデータ数
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.timer),
            title: Text('やること $index'),
            subtitle: Text('結果: 〇'),
            trailing: Text('15分'),
          );
        },
      ),
    );
  }
} 