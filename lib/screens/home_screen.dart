import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../widgets/word_card.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    // 启动动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playFadeAnimation();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _playFadeAnimation() {
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SafeArea(
              child: Column(
                children: [
                  // 顶部栏
                  _buildTopBar(wordProvider),
                  
                  // 主要内容区域
                  Expanded(
                    child: _buildMainContent(wordProvider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(WordProvider wordProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 标题
              const Text(
                '单词闪现',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              
              // 设置按钮
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  foregroundColor: const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          
          // 词典模式指示器
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: wordProvider.useLocalDictionary 
                ? Colors.green.withOpacity(0.1) 
                : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wordProvider.useLocalDictionary 
                  ? Colors.green.withOpacity(0.3) 
                  : Colors.blue.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  wordProvider.useLocalDictionary 
                    ? Icons.book 
                    : Icons.cloud,
                  size: 16,
                  color: wordProvider.useLocalDictionary 
                    ? Colors.green 
                    : Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  wordProvider.useLocalDictionary 
                    ? '本地雅思词典' 
                    : '在线API',
                  style: TextStyle(
                    fontSize: 12,
                    color: wordProvider.useLocalDictionary 
                      ? Colors.green 
                      : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(WordProvider wordProvider) {
    if (wordProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF3498DB),
            ),
            SizedBox(height: 16),
            Text(
              '加载中...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      );
    }

    if (wordProvider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              wordProvider.error,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                wordProvider.clearError();
                wordProvider.loadNextWord();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (wordProvider.currentWord == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Color(0xFF7F8C8D),
            ),
            SizedBox(height: 16),
            Text(
              '没有可用的单词',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: WordCard(
          word: wordProvider.currentWord!,
          showDefinition: wordProvider.showDefinition,
          showSynonyms: wordProvider.showSynonyms,
          showExample: wordProvider.showExample,
          onNext: () {
            _playFadeAnimation();
            wordProvider.loadNextWord();
          },
          onPlayAudio: () {
            // TODO: 实现音频播放功能
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('音频播放功能开发中...'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
