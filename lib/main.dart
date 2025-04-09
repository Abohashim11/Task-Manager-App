// ╔══════════════════════════════════════════════════════════════════════════════
// ║ تطبيق إدارة المهام - Task Manager Application
// ║ تم التطوير بواسطة: Aohashim
// ║ الإصدار: 1.0.0
// ╚══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lottie/lottie.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ║ نقطة بداية التطبيق
// ═══════════════════════════════════════════════════════════════════════════════
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskManagerApp());
}

// ═══════════════════════════════════════════════════════════════════════════════
// ║ التطبيق الرئيسي
// ═══════════════════════════════════════════════════════════════════════════════
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ═══════════════════════════════════════════════════════════════════════
        // ║ تخصيص الألوان الرئيسية للتطبيق
        // ═══════════════════════════════════════════════════════════════════════
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // اللون الرئيسي - بنفسجي
          primary: const Color(0xFF6750A4), // اللون الأساسي
          secondary: const Color(0xFFFF8A65), // اللون الثانوي - برتقالي
          background: const Color(0xFFF6F6F6), // لون الخلفية - رمادي فاتح
        ),
        useMaterial3: true,
        // ═══════════════════════════════════════════════════════════════════════
        // ║ تخصيص الخطوط في التطبيق
        // ═══════════════════════════════════════════════════════════════════════
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Lexend'),
          displayMedium: TextStyle(fontFamily: 'Lexend'),
          displaySmall: TextStyle(fontFamily: 'Lexend'),
          headlineLarge: TextStyle(fontFamily: 'Lexend'),
          headlineMedium: TextStyle(fontFamily: 'Lexend'),
          headlineSmall: TextStyle(fontFamily: 'Lexend'),
          titleLarge: TextStyle(fontFamily: 'Lexend'),
          titleMedium: TextStyle(fontFamily: 'Lexend'),
          titleSmall: TextStyle(fontFamily: 'Lexend'),
          bodyLarge: TextStyle(fontFamily: 'Lexend'),
          bodyMedium: TextStyle(fontFamily: 'Lexend'),
          bodySmall: TextStyle(fontFamily: 'Lexend'),
          labelLarge: TextStyle(fontFamily: 'Lexend'),
          labelMedium: TextStyle(fontFamily: 'Lexend'),
          labelSmall: TextStyle(fontFamily: 'Lexend'),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ║ نموذج المهمة
// ═══════════════════════════════════════════════════════════════════════════════
class Task {
  String title; // عنوان المهمة
  String description; // وصف المهمة
  bool isCompleted; // حالة إكمال المهمة
  DateTime dueDate; // تاريخ استحقاق المهمة

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// ║ الصفحة الرئيسية
// ═══════════════════════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ═══════════════════════════════════════════════════════════════════════════
  // ║ المتغيرات الرئيسية
  // ═══════════════════════════════════════════════════════════════════════════
  final List<Task> _tasks = []; // قائمة المهام
  final _titleController = TextEditingController(); // متحكم عنوان المهمة
  final _descriptionController = TextEditingController(); // متحكم وصف المهمة
  DateTime _selectedDay = DateTime.now(); // اليوم المحدد
  DateTime _focusedDay = DateTime.now(); // اليوم المُركز عليه
  CalendarFormat _calendarFormat = CalendarFormat.week; // تنسيق التقويم
  bool _isLoading = false; // حالة التحميل

  // ═══════════════════════════════════════════════════════════════════════════
  // ║ رسائل تحفيزية
  // ═══════════════════════════════════════════════════════════════════════════
  final List<String> _motivationalQuotes = [
    "Success starts with one small step",
    "Make today count",
    "Progress, not perfection",
    "Every day is a new opportunity",
    "Small steps, big changes",
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // ║ الحصول على رسالة تحفيزية عشوائية
  // ═══════════════════════════════════════════════════════════════════════════
  String get _randomQuote =>
      _motivationalQuotes[DateTime.now().day % _motivationalQuotes.length];

  // ═══════════════════════════════════════════════════════════════════════════
  // ║ عرض رسالة خطأ
  // ═══════════════════════════════════════════════════════════════════════════
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ║ إضافة مهمة جديدة
  // ═══════════════════════════════════════════════════════════════════════════
  void _addTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Task Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              Text(
                'Due Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2100),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) {
                      _showErrorSnackBar('Please enter a task title');
                      return;
                    }
                    setState(() {
                      _tasks.add(
                        Task(
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          dueDate: _selectedDay,
                        ),
                      );
                    });
                    Navigator.pop(context);
                    _titleController.clear();
                    _descriptionController.clear();
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ║ تصفية المهام حسب التاريخ المحدد
  // ═══════════════════════════════════════════════════════════════════════════
  List<Task> get _filteredTasks {
    return _tasks
        .where((task) => isSameDay(task.dueDate, _selectedDay))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6750A4), // بنفسجي
              Color(0xFFFF8A65), // برتقالي
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Task Manager',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Today, ${DateFormat('MMMM d').format(DateTime.now())}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 7)),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredTasks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/task_animation.json',
                                    width: 200,
                                    height: 200,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.task_alt,
                                        size: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _randomQuote,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start your day with a simple goal ✨',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = _filteredTasks[index];
                                return Dismissible(
                                  key: Key(task.title + index.toString()),
                                  background: Container(
                                    color: Theme.of(context).colorScheme.error,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      _tasks.remove(task);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Task deleted'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            setState(() {
                                              _tasks.add(task);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: task.isCompleted,
                                        onChanged: (value) {
                                          setState(() {
                                            task.isCompleted = value ?? false;
                                          });
                                        },
                                      ),
                                      title: Text(
                                        task.title,
                                        style: TextStyle(
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (task.description.isNotEmpty)
                                            Text(task.description),
                                          Text(
                                            'Due: ${DateFormat('MMM d').format(task.dueDate)}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Delete Task'),
                                              content: const Text(
                                                  'Are you sure you want to delete this task?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _tasks.remove(task);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
