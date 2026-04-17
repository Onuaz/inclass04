import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: CounterWidget(
        onToggleTheme: toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDark;

  const CounterWidget({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();

  List<int> history = [];

  void saveState() {
    history.add(_counter);
  }

  void undo() {
    if (history.isNotEmpty) {
      setState(() {
        _counter = history.removeLast();
      });
    }
  }

  void increment() {
    if (_counter < 100) {
      saveState();
      setState(() {
        _counter++;
      });
    }
  }

  void decrement() {
    if (_counter > 0) {
      saveState();
      setState(() {
        _counter--;
      });
    }
  }

  void reset() {
    saveState();
    setState(() {
      _counter = 0;
    });
  }

  void setValue() {
    int? value = int.tryParse(_controller.text);

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid number")),
      );
      return;
    }

    if (value > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Limit Reached!")),
      );
      return;
    }

    saveState();
    setState(() {
      _counter = value;
    });
  }

  Color getTextColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Counter'),
        actions: [
          Icon(widget.isDark ? Icons.nightlight_round : Icons.wb_sunny),
          Switch(
            value: widget.isDark,
            onChanged: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// COUNTER DISPLAY
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue.shade100,
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 50,
                  color: getTextColor(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// SLIDER
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (value) {
              saveState();
              setState(() {
                _counter = value.toInt();
              });
            },
          ),

          const SizedBox(height: 20),

          /// BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: increment, child: const Text("+")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: decrement, child: const Text("-")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: reset, child: const Text("Reset")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: undo, child: const Text("Undo")),
            ],
          ),

          const SizedBox(height: 20),

          /// INPUT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter value (0-100)",
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: setValue,
            child: const Text("Set Value"),
          ),
        ],
      ),
    );
  }
}