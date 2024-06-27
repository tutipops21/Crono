import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});

  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Iniciar";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo siempre negro
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Cronometro',
                style: TextStyle(
                  color: widget.mode == WearMode.active
                      ? Colors.white
                      : Colors.yellow,
                  fontSize: 16.0, // Aumenta el tamaño del texto
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Icon(
                Icons.timer,
                color: widget.mode == WearMode.active
                    ? Colors.green
                    : Colors.yellow,
                size: 48.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  color: widget.mode == WearMode.active
                      ? Colors.green
                      : Colors.yellow,
                  fontSize: 24.0, // Aumenta el tamaño del texto
                ),
              ),
            ),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.mode == WearMode.active
                ? Color.fromARGB(255, 10, 10, 10)
                : Color.fromARGB(255, 40, 40, 40), // Color de fondo del botón
            foregroundColor: widget.mode == WearMode.active
                ? Colors.white
                : Colors.yellow, // Color del texto del botón
          ),
          onPressed: _handleStartStop,
          child: Text(_status),
        ),
        if (widget.mode == WearMode.active) // Mostrar solo en modo activo
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  255, 10, 10, 10), // Color de fondo del botón
              foregroundColor: const Color.fromARGB(
                  255, 253, 253, 253), // Color del texto del botón
            ),
            onPressed: _handleReset,
            child: const Text("Resetear"),
          ),
      ],
    );
  }

  void _handleStartStop() {
    if (_status == "Iniciar") {
      _startTimer();
    } else if (_status == "Parar") {
      _timer.cancel();
      setState(() {
        _status = "Continuar";
      });
    } else if (_status == "Continuar") {
      _startTimer();
    }
  }

  void _handleReset() {
    if (_timer != null) {
      _timer.cancel();
      setState(() {
        _count = 0;
        _strCount = "00:00:00";
        _status = "Iniciar";
      });
    }
  }

  void _startTimer() {
    _status = "Parar";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
