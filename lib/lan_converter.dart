import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class LanguageConverter extends StatefulWidget {
  @override
  _LanguageConverterState createState() => _LanguageConverterState();
}

class _LanguageConverterState extends State<LanguageConverter> {
  final TextEditingController _controller = TextEditingController();
  String _translatedText = '';

  // List of available language codes (you can add more)
  final List<String> languageCodes = [
    'en', 'es', 'fr', 'de', 'it', 'ja', 'zh', 'ar', 'pt', 'ru', 'ko', 'hi', 'bn', 'te', 'mr', 'ta', 'ur', 'gu', 'ml',
    'kn', 'pa', 'or', 'mai', 'bho', 'as', 'sd', 'kok', 'doi', 'sat', 'ks', 'ne', 'sa'
  ];

  String _fromLanguage = 'en'; // Default from language is English
  String _toLanguage = 'es';   // Default to language is Spanish

  // Instance of the Google Translator
  final GoogleTranslator _translator = GoogleTranslator();

  // Speech-to-Text instance
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Translate function
  Future<void> _translateText() async {
    try {
      final inputText = _controller.text;

      // Translate the text using the selected languages
      var translated = await _translator.translate(inputText, from: _fromLanguage, to: _toLanguage);

      setState(() {
        _translatedText = translated.text;
      });
    } catch (e) {
      setState(() {
        _translatedText = "Error: Unable to translate";
      });
      print('Translation error: $e');
    }
  }

  // Request microphone permission
  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      print('Microphone permission granted');
    } else if (status.isDenied) {
      print('Microphone permission denied');
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
    }
  }

  // Start or stop listening for speech input
  void _listenForSpeech() async {
    // Request microphone permission before starting speech recognition
    PermissionStatus status = await Permission.microphone.status;
    if (status.isGranted) {
      if (!_isListening) {
        bool available = await _speech.initialize();
        if (available) {
          setState(() {
            _isListening = true;
          });
          _speech.listen(onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          });
        }
      } else {
        setState(() {
          _isListening = false;
        });
        _speech.stop();
      }
    } else {
      print('Microphone permission is not granted');
      // Request permission again if denied
      _requestPermissions();
    }
  }

  @override
  void initState() {
    super.initState();
    // Request permissions on app startup
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting the source language
            Text('From Language:'),
            DropdownButton<String>(
              value: _fromLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _fromLanguage = newValue!;
                });
              },
              items: languageCodes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getLanguageName(value)),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // TextField to enter the text to be translated with voice input button
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: _listenForSpeech,
                  tooltip: _isListening ? 'Stop listening' : 'Start listening',
                ),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown for selecting the target language
            Text('To Language:'),
            DropdownButton<String>(
              value: _toLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _toLanguage = newValue!;
                });
              },
              items: languageCodes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getLanguageName(value)),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Translate button
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 16),

            // Display translated text
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get the full language name from the language code
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en': return 'English';
      case 'es': return 'Spanish';
      case 'fr': return 'French';
      case 'de': return 'German';
      case 'it': return 'Italian';
      case 'ja': return 'Japanese';
      case 'zh': return 'Chinese';
      case 'ar': return 'Arabic';
      case 'pt': return 'Portuguese';
      case 'ru': return 'Russian';
      case 'ko': return 'Korean';
      case 'hi': return 'Hindi';
      case 'bn': return 'Bengali';
      case 'te': return 'Telugu';
      case 'mr': return 'Marathi';
      case 'ta': return 'Tamil';
      case 'ur': return 'Urdu';
      case 'gu': return 'Gujarati';
      case 'ml': return 'Malayalam';
      case 'kn': return 'Kannada';
      case 'pa': return 'Punjabi';
      case 'or': return 'Odia';
      case 'mai': return 'Maithili';
      case 'bho': return 'Bhojpuri';
      case 'as': return 'Assamese';
      case 'sd': return 'Sindhi';
      case 'kok': return 'Konkani';
      case 'doi': return 'Dogri';
      case 'sat': return 'Santali';
      case 'ks': return 'Kashmiri';
      case 'ne': return 'Nepali';
      case 'sa': return 'Sanskrit';
      default: return 'Unknown';
    }
  }
}
