import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

import '../services/answer_service.dart';
import '../services/storage_service.dart';
import '../models/magic_answer.dart';
import 'library_screen.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  final _storage = StorageService();
  final _answers = AnswerService();
  final _player = AudioPlayer();
  bool _revealed = false;

  bool _loading = true;
  MagicAnswer? _picked;

  @override
  void initState() {
    super.initState();
    _pickAndSave();
  }

  Future<void> _pickAndSave() async {
    final discovered = await _storage.loadDiscoveredIds();
    final picked = _answers.pickRandom(discoveredIds: discovered);

    discovered.add(picked.id);
    await _storage.saveDiscoveredIds(discovered);
    await _storage.saveLastUsedAt(DateTime.now());
    await _player.play(AssetSource('sfx/page_flip.wav'));

    setState(() {
      _picked = picked;
      _loading = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _revealed = true);
  }

  void _goLibrary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LibraryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _picked == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final a = _picked!;

  return Scaffold(
  appBar: AppBar(title: const Text('계시')),
  body: Stack(
    children: [
      // 배경 그라데이션(몽환)
      Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.2,
            colors: [Color(0xFF302B63), Color(0xFF0F0C29)],
          ),
        ),
      ),

      Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
            color: Colors.black.withValues(alpha: 0.25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // "책" 아이콘/이미지 (열리는 느낌)
              const Icon(Icons.menu_book, size: 72)
                  .animate()
                  .scale(duration: 450.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 18),

              // 이미지: reveal 이후 나타나게
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: !_revealed
                    ? const SizedBox(height: 180)
                    : SizedBox(
                        key: const ValueKey('img'),
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(a.imageAsset, fit: BoxFit.cover, width: double.infinity),
                        ),
                      ).animate().fadeIn(duration: 400.ms).blur(begin: const Offset(6, 6), end: const Offset(0, 0)),
              ),

              const SizedBox(height: 18),

              // 문구: reveal 이후 “타자” 느낌(간단 버전: 페이드+슬라이드)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: !_revealed
                    ? const Text('…', key: ValueKey('dots'))
                    : Text(
                        a.text,
                        key: const ValueKey('text'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
              ),

              const SizedBox(height: 14),

              AnimatedOpacity(
                opacity: _revealed ? 1 : 0,
                duration: const Duration(milliseconds: 450),
                child: Text(
                  '이 문장을 마음속에 새기세요.\n마력은 1시간 뒤 회복됩니다.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 18),

              // 버튼은 마지막에
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: !_revealed
                    ? const SizedBox(height: 44)
                    : FilledButton(
                        key: const ValueKey('btn'),
                        onPressed: _goLibrary,
                        child: const Text('책장으로'),
                      ).animate().fadeIn(duration: 450.ms),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  );
  }

}
