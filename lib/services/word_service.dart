import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../data/ielts_vocabulary.dart';

class WordService {
  static const String _wordsKey = 'flash_words_data';
  
  List<Word> _words = [];
  late SharedPreferences _prefs;
  
  // 模拟词汇数据（实际项目中会从API获取）
  static const List<Map<String, dynamic>> _sampleWords = [
    {
      'word': 'Serendipity',
      'definition': '意外发现美好事物的能力',
      'pronunciation': '/ˌserənˈdipədē/',
      'synonyms': ['chance', 'fortune', 'luck'],
      'example': 'Finding this book was pure serendipity.',
      'level': 'intermediate',
    },
    {
      'word': 'Ephemeral',
      'definition': '短暂的，瞬息的',
      'pronunciation': '/əˈfem(ə)rəl/',
      'synonyms': ['temporary', 'fleeting', 'transient'],
      'example': 'The beauty of cherry blossoms is ephemeral.',
      'level': 'advanced',
    },
    {
      'word': 'Ubiquitous',
      'definition': '无处不在的，普遍存在的',
      'pronunciation': '/juːˈbɪkwɪtəs/',
      'synonyms': ['omnipresent', 'universal', 'widespread'],
      'example': 'Smartphones have become ubiquitous in modern life.',
      'level': 'advanced',
    },
    {
      'word': 'Eloquent',
      'definition': '雄辩的，有说服力的',
      'pronunciation': '/ˈeləkwənt/',
      'synonyms': ['articulate', 'fluent', 'persuasive'],
      'example': 'She gave an eloquent speech about climate change.',
      'level': 'intermediate',
    },
    {
      'word': 'Resilient',
      'definition': '有韧性的，能恢复的',
      'pronunciation': '/rɪˈzɪljənt/',
      'synonyms': ['flexible', 'adaptable', 'tough'],
      'example': 'Children are remarkably resilient to adversity.',
      'level': 'intermediate',
    },
    {
      'word': 'Mellifluous',
      'definition': '甜美的，悦耳的',
      'pronunciation': '/məˈliflo͞oəs/',
      'synonyms': ['sweet', 'harmonious', 'melodious'],
      'example': 'Her mellifluous voice captivated the audience.',
      'level': 'advanced',
    },
    {
      'word': 'Perseverance',
      'definition': '毅力，坚持不懈',
      'pronunciation': '/ˌpərsəˈvirəns/',
      'synonyms': ['persistence', 'determination', 'tenacity'],
      'example': 'Success comes through perseverance and hard work.',
      'level': 'beginner',
    },
    {
      'word': 'Innovation',
      'definition': '创新，革新',
      'pronunciation': '/ˌinəˈvāSH(ə)n/',
      'synonyms': ['creativity', 'invention', 'novelty'],
      'example': 'The company is known for its innovation in technology.',
      'level': 'intermediate',
    },
  ];

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadWords();
    
    // 如果数据库为空，初始化示例数据
    if (_words.isEmpty) {
      await _initializeSampleData();
    }
  }

  Future<void> _loadWords() async {
    final wordsJson = _prefs.getStringList(_wordsKey) ?? [];
    _words = wordsJson.map((json) => Word.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _saveWords() async {
    final wordsJson = _words.map((word) => jsonEncode(word.toJson())).toList();
    await _prefs.setStringList(_wordsKey, wordsJson);
  }

  Future<void> _initializeSampleData() async {
    // 使用雅思词汇数据初始化
    final ieltsWords = IeltsVocabulary.getIeltsWords();
    _words.addAll(ieltsWords);
    await _saveWords();
  }

  Future<Word?> getRandomWord({WordLevel? level}) async {
    List<Word> words = List.from(_words);
    
    if (level != null) {
      words = words.where((word) => word.level == level).toList();
    }
    
    if (words.isEmpty) {
      return null;
    }
    
    final random = Random();
    return words[random.nextInt(words.length)];
  }

  Future<List<Word>> getAllWords() async {
    return List.from(_words);
  }

  Future<void> addWord(Word word) async {
    _words.add(word);
    await _saveWords();
  }

  Future<void> deleteWord(Word word) async {
    _words.removeWhere((w) => w.word == word.word);
    await _saveWords();
  }

  Future<void> updateWord(Word word) async {
    final index = _words.indexWhere((w) => w.word == word.word);
    if (index != -1) {
      _words[index] = word;
      await _saveWords();
    }
  }

  // 设置相关方法
  Future<void> setShowInterval(int minutes) async {
    await _prefs.setInt('showInterval', minutes);
  }

  Future<int> getShowInterval() async {
    return _prefs.getInt('showInterval') ?? 15;
  }

  Future<void> setShowDefinition(bool show) async {
    await _prefs.setBool('showDefinition', show);
  }

  Future<bool> getShowDefinition() async {
    return _prefs.getBool('showDefinition') ?? true;
  }

  Future<void> setShowSynonyms(bool show) async {
    await _prefs.setBool('showSynonyms', show);
  }

  Future<bool> getShowSynonyms() async {
    return _prefs.getBool('showSynonyms') ?? true;
  }

  Future<void> setShowExample(bool show) async {
    await _prefs.setBool('showExample', show);
  }

  Future<bool> getShowExample() async {
    return _prefs.getBool('showExample') ?? true;
  }

  Future<void> setTheme(String theme) async {
    await _prefs.setString('theme', theme);
  }

  Future<String> getTheme() async {
    return _prefs.getString('theme') ?? 'light';
  }

  Future<void> setUseLocalDictionary(bool useLocal) async {
    await _prefs.setBool('useLocalDictionary', useLocal);
  }

  Future<bool> getUseLocalDictionary() async {
    return _prefs.getBool('useLocalDictionary') ?? true; // 默认使用本地词典
  }

  // API相关方法（模拟）
  Future<List<Word>> fetchWordsFromAPI() async {
    // 这里可以集成真实的API，如Wordnik、Oxford等
    // 目前返回模拟数据
    await Future.delayed(Duration(seconds: 1)); // 模拟网络延迟
    
    final random = Random();
    final count = random.nextInt(5) + 3; // 3-7个单词
    final words = <Word>[];
    
    for (int i = 0; i < count; i++) {
      final wordData = _sampleWords[random.nextInt(_sampleWords.length)];
      final word = Word.fromJson(wordData);
      words.add(word);
    }
    
    return words;
  }
}
