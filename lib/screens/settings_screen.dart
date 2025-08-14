import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../models/word.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2C3E50),
      ),
      body: Consumer<WordProvider>(
        builder: (context, wordProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE3F2FD),
                  const Color(0xFFF3E5F5),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  '显示设置',
                  [
                    _buildSwitchTile(
                      '显示定义',
                      '显示单词的中文定义',
                      wordProvider.showDefinition,
                      (value) => wordProvider.setShowDefinition(value),
                    ),
                    _buildSwitchTile(
                      '显示同义词',
                      '显示单词的同义词',
                      wordProvider.showSynonyms,
                      (value) => wordProvider.setShowSynonyms(value),
                    ),
                    _buildSwitchTile(
                      '显示例句',
                      '显示包含该单词的例句',
                      wordProvider.showExample,
                      (value) => wordProvider.setShowExample(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildSection(
                  '定时设置',
                  [
                    _buildSliderTile(
                      '显示间隔',
                      '${wordProvider.showInterval} 分钟',
                      wordProvider.showInterval.toDouble(),
                      5.0,
                      60.0,
                      (value) => wordProvider.setShowInterval(value.round()),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildSection(
                  '词典设置',
                  [
                    _buildSwitchTile(
                      '使用本地雅思词典',
                      '使用内置的雅思词汇库，无需网络连接',
                      wordProvider.useLocalDictionary,
                      (value) => wordProvider.setUseLocalDictionary(value),
                    ),
                    if (!wordProvider.useLocalDictionary)
                      _buildListTile(
                        '从API更新',
                        '从在线API获取新单词',
                        Icons.cloud_download,
                        () => _updateFromAPI(context, wordProvider),
                      ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildSection(
                  '难度筛选',
                  [
                    _buildDifficultySelector(wordProvider),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF3498DB),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, double value, double min, double max, ValueChanged<double> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            onChanged: onChanged,
            activeColor: const Color(0xFF3498DB),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3498DB)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDifficultySelector(WordProvider wordProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择难度',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: WordLevel.values.map((level) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => wordProvider.loadNextWordByLevel(level),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getLevelColor(level).withOpacity(0.1),
                      foregroundColor: _getLevelColor(level),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(level.displayName),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
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

  void _updateFromAPI(BuildContext context, WordProvider wordProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新词汇库'),
        content: const Text('确定要从在线API获取新单词吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              wordProvider.fetchWordsFromAPI();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('正在从API获取新单词...')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
