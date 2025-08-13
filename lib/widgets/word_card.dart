import 'package:flutter/material.dart';
import '../models/word.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final bool showDefinition;
  final bool showSynonyms;
  final bool showExample;
  final VoidCallback? onNext;
  final VoidCallback? onPlayAudio;

  const WordCard({
    Key? key,
    required this.word,
    this.showDefinition = true,
    this.showSynonyms = true,
    this.showExample = true,
    this.onNext,
    this.onPlayAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 难度标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getLevelColor(word.level).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              word.level.displayName,
              style: TextStyle(
                color: _getLevelColor(word.level),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 单词
          Text(
            word.word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          
          // 音标
          if (word.pronunciation != null) ...[
            const SizedBox(height: 8),
            Text(
              word.pronunciation!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          const SizedBox(height: 24),
          
          // 定义
          if (showDefinition) ...[
            _buildSection(
              '定义',
              word.definition,
              Icons.translate,
            ),
            const SizedBox(height: 16),
          ],
          
          // 同义词
          if (showSynonyms && word.synonyms.isNotEmpty) ...[
            _buildSection(
              '同义词',
              word.synonyms.join(', '),
              Icons.sync,
            ),
            const SizedBox(height: 16),
          ],
          
          // 例句
          if (showExample) ...[
            _buildSection(
              '例句',
              word.example,
              Icons.format_quote,
            ),
            const SizedBox(height: 24),
          ],
          
          // 底部按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 播放音频按钮
              if (word.audioUrl != null)
                IconButton(
                  onPressed: onPlayAudio,
                  icon: const Icon(Icons.volume_up),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
                    foregroundColor: const Color(0xFF3498DB),
                  ),
                ),
              
              // 下一个单词按钮
              ElevatedButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('下一个'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF7F8C8D),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2C3E50),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Color _getLevelColor(WordLevel level) {
    switch (level) {
      case WordLevel.beginner:
        return const Color(0xFF4CAF50);
      case WordLevel.intermediate:
        return const Color(0xFFFF9800);
      case WordLevel.advanced:
        return const Color(0xFFF44336);
    }
  }
}
