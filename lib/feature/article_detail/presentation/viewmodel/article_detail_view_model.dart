import 'dart:io';
import 'package:english_reading_app/config/localization/locale_constants.dart';
import 'package:english_reading_app/product/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

/// initiliaze durmunu ui da start ve puse da if ile kontrol etmen gerekir mi?
enum TtsState { playing, stopped, paused, continued }

class ArticleDetailViewModel extends ChangeNotifier {
  final FlutterTts flutterTts = FlutterTts();
  double _fontSize = 16;
  double get fontSize => _fontSize;
  ArticleModel? _article;
  ArticleModel? get article => _article;

  void setArticle(ArticleModel? article) {
    _article = article;
    notifyListeners();
  }

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void setLoading(bool loading) {
    notifyListeners();
  }

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying =>
      ttsState == TtsState.playing || ttsState == TtsState.continued;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;
  int _lastPausedOffset = 0;
  int _currentWordStart = 0;
  int _currentWordEnd = 0;

  int get lastPausedOffset => _lastPausedOffset;
  int get currentWordStart => _currentWordStart;
  int get currentWordEnd => _currentWordEnd;

  String get currentWord =>
      _article?.text?.substring(_currentWordStart, _currentWordEnd) ?? '';

  bool _isTextMaySpeakable = false;
  bool get isTextMaySpeakable => _isTextMaySpeakable;

  bool _isMediaSectionVisible = false;
  bool get isMediaSection => _isMediaSectionVisible;

  void changeMediaSectionVisibility(bool value) {
    _isMediaSectionVisible = value;
  }

  double get progressValue {
    final totalLength = article?.text?.length ?? 1;
    return currentWordStart >= totalLength
        ? 1.0
        : currentWordStart / totalLength;
  }

  double _currentSpeed = 1;
  final List<double> _speedOptions = [0.5, 1.0, 1.5, 2.0];
  double get currentSpeed => _currentSpeed;
  String get currentSpeedText => '${_currentSpeed}x';
  // Hız değerlerini flutter_tts oranına dönüştüren yardımcı metot
  double _getTtsRate(double speed) {
    switch (speed) {
      case 0.5:
        return 0.25; // 0.5x → 0.25
      case 1.0:
        return 0.5; // 1x → 0.5
      case 1.5:
        return 0.75; // 1.5x → 0.75
      case 2.0:
        return 1; // 2x → 1.0
      default:
        return 0.5; // Fallback
    }
  }

  Future<void> toggleSpeed() async {
    final currentIndex = _speedOptions.indexOf(_currentSpeed);
    final nextIndex = (currentIndex + 1) % _speedOptions.length;
    _currentSpeed = _speedOptions[nextIndex];
    await flutterTts.setSpeechRate(_getTtsRate(_currentSpeed));
    await pause();
    await speak();
  }

  Future<void> initTts() async {
    _isTextMaySpeakable = await isContentWithinTtsLimit();
    if (_isTextMaySpeakable) {
      await _setAwaitOptions();
      await flutterTts.setLanguage(LocaleConstants.enLocale.languageCode);
      await flutterTts.setVolume(1);
      await flutterTts.setSpeechRate(_getTtsRate(_currentSpeed));
      flutterTts
        ..setStartHandler(() {
          ttsState = TtsState.playing;
          notifyListeners();
        })
        ..setCompletionHandler(() {
          ttsState = TtsState.stopped;
          _currentWordStart = article?.text?.length ?? 1; //for progress bar
          notifyListeners();
        })
        ..setCancelHandler(() {
          ttsState = TtsState.stopped;
          notifyListeners();
        })
        ..setPauseHandler(() {
          ttsState = TtsState.paused;
          notifyListeners();
        })
        ..setContinueHandler(() {
          ttsState = TtsState.continued;
          notifyListeners();
        })
        ..setErrorHandler((msg) {
          ttsState = TtsState.stopped;
          notifyListeners();
        }); // Yeni eklenen kısım: Kelime takibi için
      if (isAndroid) {
        flutterTts.setProgressHandler((
          String text,
          int startOffset,
          int endOffset,
          String word,
        ) {
          // EĞER PAUSE'DAN DEVAM EDİYORSA, OFFSET'LERE LAST PAUSED OFFSET'E GÖRE EKLE
          if (ttsState == TtsState.paused || ttsState == TtsState.continued) {
            _currentWordStart = _lastPausedOffset + startOffset;
            _currentWordEnd = _lastPausedOffset + endOffset;
          } else {
            _currentWordStart = startOffset;
            _currentWordEnd = endOffset;
          }

          notifyListeners();
        });
      }
      notifyListeners();
    } else {
      // log+anallytica
      ttsState = TtsState.stopped;
      notifyListeners();
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> speak() async {
    changeMediaSectionVisibility(true);
    final content = _article?.text;
    if (content != null && content.isNotEmpty) {
      var textToSpeak = content;

      // EĞER DAHA ÖNCE PAUSE EDİLDİYSE, KALDIĞI YERDEN BAŞLAT
      if ((ttsState == TtsState.paused) && _lastPausedOffset > 0) {
        textToSpeak = content.substring(_lastPausedOffset);
      }

      await flutterTts.speak(textToSpeak);
      // EĞER PAUSE'DAN DEVAM EDİYORSA, OFFSET'İ AYARLA
      if (ttsState == TtsState.paused) {
        _currentWordStart = _lastPausedOffset;
        _currentWordEnd = _lastPausedOffset;
        notifyListeners();
      }
    }
  }

  Future<void> stop() async {
    changeMediaSectionVisibility(false);
    final result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    final result = await flutterTts.pause();
    if (result == 1) {
      _lastPausedOffset = _currentWordStart;
      ttsState = TtsState.paused;
      notifyListeners();
    }
  }

  Future<bool> isContentWithinTtsLimit() async {
    final contentLenght = _article?.text?.length ?? 0;
    final ttsEngineSpeechLimit = await flutterTts.getMaxSpeechInputLength ?? 0;
    return contentLenght < ttsEngineSpeechLimit;
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
