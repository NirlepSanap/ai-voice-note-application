// main.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'firebase_options.dart'; // 👈 Required for Firebase initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Voice Notes',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the mic to start recording';
  String _summary = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _signInAnonymously();
  }

  Future<void> _signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() => _text = val.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _summarizeAndSave() async {
    if (_text.trim().isEmpty) return;

    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('summarizeNote');
      final result = await callable.call({'noteText': _text});
      _summary = result.data['summary'];

      await FirebaseFirestore.instance.collection('notes').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'text': _text,
        'summary': _summary,
        'timestamp': Timestamp.now(),
      });

      setState(() {});
    } catch (e) {
      debugPrint('Error summarizing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Voice Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recorded Text:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_text),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _summarizeAndSave, child: Text("Summarize & Save")),
            SizedBox(height: 16),
            Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_summary),
            Divider(),
            Expanded(child: _buildNotesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final notes = snapshot.data!.docs;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note['summary'] ?? 'No summary'),
              subtitle: Text(note['text'] ?? ''),
            );
          },
        );
      },
    );
  }
}
