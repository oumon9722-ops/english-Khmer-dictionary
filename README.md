# Smart Dictionary (English - Khmer) 📚🇰🇭

An offline-first, feature-rich English-to-Khmer mobile dictionary application developed with **Flutter**, **GetX**, and **SQLite**. 

---

## 🎓 Academic Information
- **Institution**: National University of Battambang (NUBB)
- **Academic Year**: Year 4, Semester 1
- **Course**: Hybrid Mobile App Development
- **Authors & Contributors**:
  - **Hor Tola** ([@tola-12](https://github.com/tola-12) / hortola780@gmail.com)
  - **Oum On** ([@oumon9722-ops](https://github.com/oumon9722-ops) / oumon9722@gmail.com)
  - **Ouch Rothphanith** (ouchsophanith99@gmail.com)
  - **Chetra SreyPhim** (chitrasreyphim045@gmail.com)
  - **Voeurn Sothearoth** (voeunsothearoth1212@gmail.com)
  - **Nil Mengieng** (jralbert725@gmail.com)

---

## 🌟 Key Features

- **📖 36,000+ Offline Words**: Preloaded with a comprehensive SQLite database containing English words, IPA phonetics, Khmer phonetics, parts of speech, and Khmer definitions.
- **⚡ Smart Ranked Search**: Fast search engine that intelligently prioritizes exact matches, prefix matches, and partial matches.
- **🎙️ Voice Search**: Hands-free search powered by `speech_to_text`.
- **🔊 Native Text-to-Speech (TTS)**: Clear English audio pronunciation for every word powered by `flutter_tts`.
- **🔖 Persistent Bookmarks / Favorites**: Save important words for quick study with permanent SQLite storage across app sessions.
- **🕒 Persistent Search History**: Automatically tracks viewed words with one-tap removal and clear history dialogs.
- **✏️ Add & Edit Words**: Users can add new vocabulary or update existing definitions directly into the local database.
- **🌓 Light & Dark Mode**: Full theme customization adapting automatically across all screens.
- **📋 Share & Copy**: Effortlessly copy phonetics and definitions to the clipboard or share them via external apps.

---

## 🛠️ Architecture & Tech Stack

| Component | Technology |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart SDK >= 3.0.0) |
| **State Management** | [GetX](https://pub.dev/packages/get) |
| **Local Database** | [SQLite](https://pub.dev/packages/sqflite) (`sqflite` & `path`) |
| **Speech-to-Text** | [speech_to_text](https://pub.dev/packages/speech_to_text) |
| **Text-to-Speech** | [flutter_tts](https://pub.dev/packages/flutter_tts) |
| **HTML Parser & Rendering** | [flutter_html](https://pub.dev/packages/flutter_html) & [html](https://pub.dev/packages/html) |
| **Sharing & System** | [share_plus](https://pub.dev/packages/share_plus) & Flutter Services |

---

## 📁 Project Structure

```text
lib/
├── Controller/
│   └── mydata.dart         # GetX controller for state, search filter, and theme
├── Screens/
│   ├── splash.dart         # Welcome & Onboarding screen
│   ├── home.dart           # Main dictionary search & word list
│   ├── detail.dart         # Word details, definitions, TTS & share
│   ├── favorite.dart       # Bookmarked favorite words
│   ├── history.dart        # Search & lookup history
│   ├── insertword.dart     # Add new word or edit existing word
│   ├── setting.dart        # User preferences, TTS test & dark mode
│   └── aboutapp.dart       # App info, developers & open-source licenses
├── dbhelper.dart           # SQLite helper, asset preloading & persistence
└── main.dart               # App entrypoint, theme configurations & routes
assets/
└── englishkhmer.db         # Pre-populated SQLite database (36,334 words)
```

---

## 🚀 Getting Started & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.0 or higher)
- Android Studio / Xcode / VS Code with Flutter extension
- An Android device or emulator (Android 7.0+ recommended) or iOS Simulator

### Run the App

1. **Clone the repository**:
   ```bash
   git clone https://github.com/oumon9722-ops/english-Khmer-dictionary.git
   cd english-Khmer-dictionary
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on connected device / emulator**:
   ```bash
   flutter run
   ```

---

## 📜 License & Copyright
Developed for academic purposes at National University of Battambang (NUBB).  
© 2026 Smart Dictionary Team (NUBB). All rights reserved.
