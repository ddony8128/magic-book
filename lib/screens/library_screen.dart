import 'package:flutter/material.dart';

import '../data/answers.dart';
import '../services/storage_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _storage = StorageService();
  bool _loading = true;
  Set<String> _discovered = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ids = await _storage.loadDiscoveredIds();
    setState(() {
      _discovered = ids;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = kMagicAnswers.length;
    final found = _discovered.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('책장'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('발견 $found / $total', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: kMagicAnswers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final a = kMagicAnswers[index];
            final discovered = _discovered.contains(a.id);
            return _BookTile(
              title: discovered ? a.text : '아직 봉인된 페이지',
              discovered: discovered,
              onTap: discovered
                  ? () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('기록'),
                          content: Text(a.text),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
                          ],
                        ),
                      )
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  final String title;
  final bool discovered;
  final VoidCallback? onTap;

  const _BookTile({
    required this.title,
    required this.discovered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = discovered ? Colors.white10 : Colors.white.withOpacity(0.05);
    final border = discovered ? Colors.white24 : Colors.white12;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: bg,
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              discovered ? Icons.menu_book : Icons.menu_book_outlined,
              size: 42,
              color: discovered ? Colors.white : Colors.white38,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: discovered ? Colors.white : Colors.white38,
                      height: 1.3,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
