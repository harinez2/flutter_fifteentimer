import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // 実装時に有効化

class HistoryItem {
  final String task;
  final DateTime dateTime;
  final int minutes;
  HistoryItem({required this.task, required this.dateTime, required this.minutes});
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  static List<HistoryItem> _history = [];

  static void addHistory(BuildContext? context, String task, int minutes, DateTime dateTime) {
    _history.insert(0, HistoryItem(task: task, dateTime: dateTime, minutes: minutes));
    if (context != null) {
      final state = context.findAncestorStateOfType<HistoryScreenState>();
      state?.setState(() {});
    }
  }

  // 今後、shared_preferences等で保存・取得処理を追加

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('履歴')),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            leading: const Icon(Icons.timer),
            title: Text(item.task),
            subtitle: Text('${DateFormat('M/d HH:mm').format(item.dateTime)}  ${item.minutes}分'),
          );
        },
      ),
    );
  }
} 