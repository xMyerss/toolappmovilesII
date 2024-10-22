import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import  'package:permission_handler/permission_handler.dart'; // Nuevo import

class SpeechTextPage extends StatefulWidget {
  @override
  _SpeechTextPageState createState() => _SpeechTextPageState();
}

class _SpeechTextPageState extends State<SpeechTextPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = 'Presiona el botón y empieza a hablar';
  double _confidence = 1.0;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _requestPermissions(); // Solicitar permisos al iniciar
  }

  // Solicitar permisos necesarios
  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _initializeSpeech();
      _initializeTts();
    } else {
      _showError('Se requiere permiso del micrófono para usar esta función');
    }
  }

  // Inicializar el reconocimiento de voz
  void _initializeSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          print('Estado del reconocimiento: $status');
          if (status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          print('Error de reconocimiento: ${errorNotification.errorMsg}');
          setState(() => _isListening = false);
          _showError('Error: ${errorNotification.errorMsg}');
        },
      );
      setState(() {}); // Actualizar UI después de la inicialización
      
      if (!_speechEnabled) {
        _showError('El reconocimiento de voz no está disponible en este dispositivo');
      }
    } catch (e) {
      print('Error al inicializar speech_to_text: $e');
      _showError('Error al inicializar el reconocimiento de voz');
    }
  }

  void _initializeTts() async {
    try {
      await _flutterTts.setLanguage("es-ES");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.7);
      await _flutterTts.setVolume(1.0);
    } catch (e) {
      print('Error al inicializar TTS: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _listen() async {
    if (!_speech.isAvailable) {
      _showError('El reconocimiento de voz no está disponible');
      return;
    }

    if (!_isListening) {
      try {
        bool available = await _speech.initialize(
          onStatus: (status) => print('onStatus: $status'),
          onError: (error) => print('onError: $error'),
        );

        if (available) {
          setState(() => _isListening = true);
          await _speech.listen(
            onResult: (result) {
              setState(() {
                _text = result.recognizedWords;
                if (result.hasConfidenceRating && result.confidence > 0) {
                  _confidence = result.confidence;
                }
                print('Texto reconocido: $_text');
                print('Confianza: $_confidence');
              });
            },
            localeId: "es-ES",
            listenMode: stt.ListenMode.dictation,
            cancelOnError: false,
            partialResults: true,
          );
        }
      } catch (e) {
        print('Error al iniciar la escucha: $e');
        setState(() => _isListening = false);
        _showError('Error al iniciar el reconocimiento de voz');
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
      print('Reconocimiento de voz detenido');
    }
  }

  Future<void> _speak() async {
    if (_text.isNotEmpty) {
      try {
        await _flutterTts.stop();
        await _flutterTts.speak(_text);
      } catch (e) {
        print('Error al reproducir texto: $e');
        _showError('Error al reproducir el texto');
      }
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor Voz a Texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                _isListening ? 'Escuchando...' : 'No escuchando',
                style: TextStyle(
                  color: _isListening ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel de confianza: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _text,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                ),
                if (_isListening)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('Reproducir texto en voz alta'),
              onPressed: _speak,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}