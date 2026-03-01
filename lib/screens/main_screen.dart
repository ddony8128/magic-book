import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import 'cooldown_screen.dart';
import 'focus_screen.dart';
import 'library_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _storage = StorageService();

  bool _loading = true;
  DateTime? _lastUsedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final last = await _storage.loadLastUsedAt();
    setState(() {
      _lastUsedAt = last;
      _loading = false;
    });
  }

  void _startFlow() {
    if (_storage.isOnCooldown(lastUsedAt: _lastUsedAt)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CooldownScreen(lastUsedAt: _lastUsedAt!)),
      ).then((_) => _load());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FocusScreen()),
    ).then((_) => _load());
  }

  void _openLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LibraryScreen()),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('마법의 고민해결 책'),
        actions: [
          IconButton(
            tooltip: '책장',
            onPressed: _openLibrary,
            icon: const Icon(Icons.auto_stories),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F0C29),
                        Color(0xFF302B63),
                        Color(0xFF24243E),
                      ],
                    ),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.menu_book, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        '마음속으로 고민을 10초간 되뇌이세요.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _startFlow,
                        child: const Text('책을 펼칠 준비'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _lastUsedAt == null
                            ? '아직 한 번도 펼치지 않았습니다.'
                            : '마지막 사용: ${_lastUsedAt!.toLocal().toString().substring(0, 19)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _openLibrary,
              icon: const Icon(Icons.collections_bookmark_outlined),
              label: const Text('책장 열기'),
            ),
            const SizedBox(height: 8),
          ],
        ),
        ),
      ),
    );
  }
}
