import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const StudyPlannerPage(),
    );
  }
}

class StudyTask {
  String subject;
  String topic;
  String date;
  String priority;
  bool completed;

  StudyTask({
    required this.subject,
    required this.topic,
    required this.date,
    required this.priority,
    this.completed = false,
  });
}

class StudyPlannerPage extends StatefulWidget {
  const StudyPlannerPage({super.key});

  @override
  State<StudyPlannerPage> createState() => _StudyPlannerPageState();
}

class _StudyPlannerPageState extends State<StudyPlannerPage> {
  final TextEditingController subjectController =
  TextEditingController();

  final TextEditingController topicController =
  TextEditingController();

  List<StudyTask> tasks = [];

  String selectedPriority = "Medium";
  DateTime selectedDate = DateTime.now();

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addTask() {
    if (subjectController.text.isNotEmpty &&
        topicController.text.isNotEmpty) {
      setState(() {
        tasks.add(
          StudyTask(
            subject: subjectController.text,
            topic: topicController.text,
            date:
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            priority: selectedPriority,
          ),
        );
      });

      subjectController.clear();
      topicController.clear();
    }
  }

  int get completedCount =>
      tasks.where((task) => task.completed).length;

  int get pendingCount =>
      tasks.where((task) => !task.completed).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedCount / tasks.length;
  }

  Color getPriorityColor(String priority) {
    if (priority == "High") {
      return Colors.red;
    } else if (priority == "Medium") {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: "Topic",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: selectedPriority,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Priority",
              ),
              items: const [
                DropdownMenuItem(
                  value: "High",
                  child: Text("High"),
                ),
                DropdownMenuItem(
                  value: "Medium",
                  child: Text("Medium"),
                ),
                DropdownMenuItem(
                  value: "Low",
                  child: Text("Low"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickDate,
              child: Text(
                "Select Date : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addTask,
              child: const Text("Add Task"),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      "Total Tasks : ${tasks.length}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Completed : $completedCount",
                    ),
                    Text(
                      "Pending : $pendingCount",
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% Completed",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    elevation: 5,
                    margin:
                    const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          setState(() {
                            task.completed = value!;
                          });
                        },
                      ),
                      title: Text(
                        task.subject,
                        style: TextStyle(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Topic: ${task.topic}"),
                          Text("Date: ${task.date}"),
                          Text(
                            "Priority: ${task.priority}",
                            style: TextStyle(
                              color: getPriorityColor(
                                  task.priority),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}