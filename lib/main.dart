import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'dart:async';

class AppSettings extends ChangeNotifier {
  Color themeColor = Colors.deepPurple;
  int timerMinutes = 15;

  // タイマー状態
  bool isRunning = false;
  bool isPaused = false;
  int remainingSeconds = 0;
  int totalSeconds = 0;
  String task = '';
  DateTime? startTime;
  int elapsedSeconds = 0;
  Timer? _timer;

  void setThemeColor(Color color) {
    themeColor = color;
    notifyListeners();
  }

  void setTimerMinutes(int minutes) {
    timerMinutes = minutes;
    notifyListeners();
  }

  void startTimer(String taskText) {
    if (isRunning) return;
    timerMinutes = timerMinutes.clamp(5, 60);
    totalSeconds = timerMinutes * 60;
    remainingSeconds = totalSeconds;
    isRunning = true;
    isPaused = false;
    task = taskText;
    startTime = DateTime.now();
    elapsedSeconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && remainingSeconds > 0) {
        remainingSeconds--;
        elapsedSeconds++;
        notifyListeners();
      } else if (remainingSeconds == 0) {
        timer.cancel();
        isRunning = false;
        isPaused = false;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    if (!isRunning) return;
    isPaused = !isPaused;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    isRunning = false;
    isPaused = false;
    remainingSeconds = totalSeconds;
    elapsedSeconds = 0;
    task = '';
    startTime = null;
    notifyListeners();
  }

  void completeTimer() {
    _timer?.cancel();
    isRunning = false;
    isPaused = false;
    // 実際に動かした時間（分）で履歴追加
    int minutes = (elapsedSeconds / 60).ceil();
    HistoryScreenState.addHistory(
      null,
      (task.isEmpty ? '-' : task),
      minutes,
      startTime ?? DateTime.now(),
    );
    remainingSeconds = totalSeconds;
    elapsedSeconds = 0;
    task = '';
    startTime = null;
    notifyListeners();
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

void main() {
  runApp(AppSettingsProvider(child: const MyApp()));
}

class AppSettingsProvider extends InheritedNotifier<AppSettings> {
  AppSettingsProvider({required Widget child})
      : super(notifier: AppSettings(), child: child);

  static AppSettings of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppSettingsProvider>()!.notifier!;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsProvider.of(context);
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return MaterialApp(
          title: '15分タイマー',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: settings.themeColor),
            scaffoldBackgroundColor: settings.themeColor.withOpacity(0.05),
          ),
          home: const HomeTabController(),
        );
      },
    );
  }
}

class HomeTabController extends StatefulWidget {
  const HomeTabController({super.key});

  @override
  State<HomeTabController> createState() => _HomeTabControllerState();
}

class _HomeTabControllerState extends State<HomeTabController> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const MainScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'タイマー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
