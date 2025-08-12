# AI Voice Notes 🎤

A Flutter mobile application that converts speech to text and generates AI-powered summaries using Firebase Cloud Functions. Record your voice notes, get intelligent summaries, and store them securely in the cloud.

## Features ✨

- **Speech-to-Text**: Real-time voice recording and transcription
- **AI Summarization**: Intelligent note summarization using cloud functions
- **Cloud Storage**: Secure storage with Firebase Firestore
- **Real-time Sync**: Live updates across devices with Firebase
- **Anonymous Authentication**: Quick access without account creation
- **Clean UI**: Simple and intuitive Material Design interface

## Screenshots 📱

*Add screenshots of your app here*

## Tech Stack 🛠️

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Cloud Functions
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth (Anonymous)
- **Speech Recognition**: speech_to_text package
- **Cloud Platform**: Firebase

## Prerequisites 📋

Before running this project, make sure you have:

- [Flutter](https://flutter.dev/docs/get-started/install) (SDK ^3.8.1)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Android Studio or VS Code with Flutter extensions
- A Firebase project set up

## Installation 🚀

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ai-voice-notes.git
   cd ai-voice-notes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable the following services:
     - Authentication (Anonymous sign-in)
     - Cloud Firestore
     - Cloud Functions
   
4. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure your app
   flutterfire configure
   ```

5. **Set up Cloud Functions**
   ```bash
   cd functions
   npm install
   firebase deploy --only functions
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── main.dart              # Main app entry point
├── firebase_options.dart  # Firebase configuration
├── models/               # Data models (if any)
├── screens/              # UI screens
├── services/             # Firebase services
└── widgets/              # Reusable UI components

functions/
├── index.js              # Cloud Functions
└── package.json          # Node.js dependencies
```

## Firebase Configuration 🔧

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{document} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### Cloud Function (Example)
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.summarizeNote = functions.https.onCall(async (data, context) => {
  const { noteText } = data;
  
  // Add your AI summarization logic here
  // This could integrate with OpenAI, Google AI, or other services
  
  const summary = await generateSummary(noteText);
  return { summary };
});
```

## Usage 📖

1. **Record Voice Note**: Tap the microphone button to start/stop recording
2. **View Transcription**: See real-time speech-to-text conversion
3. **Generate Summary**: Tap "Summarize & Save" to create an AI summary
4. **Browse Notes**: View all your saved notes and summaries in the list below

## Permissions 🔐

### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone to record voice notes.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert voice to text.</string>
```

## Contributing 🤝

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap 🗺️

- [ ] User account registration and login
- [ ] Note categories and tags
- [ ] Export notes to different formats
- [ ] Offline mode support
- [ ] Voice note playback
- [ ] Search functionality
- [ ] Dark theme support
- [ ] Multi-language speech recognition

## Known Issues 🐛

- Speech recognition may not work on older Android devices
- Internet connection required for AI summarization
- iOS simulator may not support speech recognition

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💡

If you find this project helpful, please give it a ⭐ on GitHub!

For questions or support, please open an issue in the GitHub repository.

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Firebase for backend services
- speech_to_text package contributors
- The open-source community

---

Built with ❤️ using Flutter and Firebase
