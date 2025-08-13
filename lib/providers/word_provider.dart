import 'package:flutter/foundation.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class WordProvider with ChangeNotifier {
  final WordService _wordService = WordService();
  
  Word? _currentWord;
  List<Word> _allWords = [];
  bool _isLoading = false;
  String _error = '';
  
  // 设置相关
  int _showInterval = 15;
  bool _showDefinition = true;
  bool _showSynonyms = true;
  bool _showExample = true;
  String _theme = 'light';
  
  // Getters
  Word? get currentWord => _currentWord;
  List<Word> get allWords => _allWords;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get showInterval => _showInterval;
  bool get showDefinition => _showDefinition;
  bool get showSynonyms => _showSynonyms;
  bool get showExample => _showExample;
  String get theme => _theme;
  
  Future<void> initialize() async {
    try {
      await _wordService.initialize();
      await _loadSettings();
      await _loadAllWords();
      await _loadRandomWord();
    } catch (e) {
      _error = '初始化失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> _loadSettings() async {
    _showInterval = await _wordService.getShowInterval();
    _showDefinition = await _wordService.getShowDefinition();
    _showSynonyms = await _wordService.getShowSynonyms();
    _showExample = await _wordService.getShowExample();
    _theme = await _wordService.getTheme();
    notifyListeners();
  }
  
  Future<void> _loadAllWords() async {
    _allWords = await _wordService.getAllWords();
    notifyListeners();
  }
  
  Future<void> _loadRandomWord() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _currentWord = await _wordService.getRandomWord();
      if (_currentWord == null) {
        _error = '没有可用的单词';
      }
    } catch (e) {
      _error = '加载单词失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadNextWord() async {
    await _loadRandomWord();
  }
  
  Future<void> loadNextWordByLevel(WordLevel level) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _currentWord = await _wordService.getRandomWord(level: level);
      if (_currentWord == null) {
        _error = '该难度级别没有可用的单词';
      }
    } catch (e) {
      _error = '加载单词失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addWord(Word word) async {
    try {
      await _wordService.addWord(word);
      await _loadAllWords();
    } catch (e) {
      _error = '添加单词失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> deleteWord(Word word) async {
    try {
      await _wordService.deleteWord(word);
      await _loadAllWords();
      if (_currentWord?.word == word.word) {
        await _loadRandomWord();
      }
    } catch (e) {
      _error = '删除单词失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> updateWord(Word word) async {
    try {
      await _wordService.updateWord(word);
      await _loadAllWords();
    } catch (e) {
      _error = '更新单词失败: $e';
      notifyListeners();
    }
  }
  
  // 设置相关方法
  Future<void> setShowInterval(int minutes) async {
    try {
      await _wordService.setShowInterval(minutes);
      _showInterval = minutes;
      notifyListeners();
    } catch (e) {
      _error = '设置间隔失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> setShowDefinition(bool show) async {
    try {
      await _wordService.setShowDefinition(show);
      _showDefinition = show;
      notifyListeners();
    } catch (e) {
      _error = '设置定义显示失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> setShowSynonyms(bool show) async {
    try {
      await _wordService.setShowSynonyms(show);
      _showSynonyms = show;
      notifyListeners();
    } catch (e) {
      _error = '设置同义词显示失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> setShowExample(bool show) async {
    try {
      await _wordService.setShowExample(show);
      _showExample = show;
      notifyListeners();
    } catch (e) {
      _error = '设置例句显示失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> setTheme(String theme) async {
    try {
      await _wordService.setTheme(theme);
      _theme = theme;
      notifyListeners();
    } catch (e) {
      _error = '设置主题失败: $e';
      notifyListeners();
    }
  }
  
  Future<void> fetchWordsFromAPI() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final newWords = await _wordService.fetchWordsFromAPI();
      for (final word in newWords) {
        await _wordService.addWord(word);
      }
      await _loadAllWords();
    } catch (e) {
      _error = '从API获取单词失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
