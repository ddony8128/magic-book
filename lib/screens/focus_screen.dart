import 'dart:async';
import 'package:flutter/material.dart';

import 'reveal_screen.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _start = 10;
  int _remain = _start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _remain--);
      if (_remain <= 0) {
        t.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RevealScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('집중')),
      body: SafeArea(
        child: Center(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('고민을 마음속으로 되뇌이세요.'),
            const SizedBox(height: 16),
            Text(
              '$_remain',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 16),
            const Text('…'),
          ],
        ),
        ),
      ),
    );
  }
}
