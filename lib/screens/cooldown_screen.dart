import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CooldownScreen extends StatefulWidget {
  final DateTime lastUsedAt;
  const CooldownScreen({super.key, required this.lastUsedAt});

  @override
  State<CooldownScreen> createState() => _CooldownScreenState();
}

class _CooldownScreenState extends State<CooldownScreen> {
  final _storage = StorageService();
  Timer? _timer;
  Duration _remain = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    setState(() {
      _remain = _storage.remainingCooldown(lastUsedAt: widget.lastUsedAt);
    });
    if (_remain == Duration.zero) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    String two(int x) => x.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final done = _remain == Duration.zero;

    return Scaffold(
      appBar: AppBar(title: const Text('마력 충전')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt, size: 72),
            const SizedBox(height: 16),
            Text(
              done ? '마력이 회복되었습니다.' : '마력이 회복되는 중입니다.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              done ? '이제 다시 책을 펼칠 수 있어요.' : _format(_remain),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(done ? '돌아가기' : '확인'),
            ),
          ],
        ),
      ),
    );
  }
}
