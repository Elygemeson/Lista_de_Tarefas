import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema escuro
        primarySwatch: Colors.teal,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          ),
        ),
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  void addTask(String title) {
    setState(() {
      tasks.insert(0, Task(title: title)); // Adiciona a tarefa no início
    });
    taskController.clear(); // Limpa o campo de texto
  }

  void toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone; // Alterna o estado da tarefa
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas', style: TextStyle(fontSize: 24.0)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Digite uma nova tarefa',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      addTask(taskController.text);
                    }
                  },
                  child: Text('Cadastrar', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return AnimatedTaskTile(task: tasks[index], onToggle: () => toggleTask(tasks[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const AnimatedTaskTile({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: task.isDone ? Colors.green[700] : Colors.grey[850], // Cor para concluídas e não concluídas
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18.0,
            decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: Colors.white, // Cor do texto
          ),
        ),
        value: task.isDone,
        onChanged: (bool? value) {
          onToggle();
        },
        activeColor: Colors.teal,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}
