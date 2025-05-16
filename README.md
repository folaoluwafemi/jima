# JIMA

A modern Flutter application that provides a feature-rich experience with audio playback capabilities, social authentication, and more.

## 🚀 Features

- Audio playback with background support
- Social authentication (Google, Facebook)
- YouTube video integration
- Secure storage and data management
- Responsive UI with material design
- State management using Vanilla State
- API integration with Dio
- Local storage with Hive
- Environment configuration support
- Supabase backend integration

## 📋 Prerequisites

- Flutter SDK ^3.6.2
- Dart SDK (compatible with Flutter SDK version)
- Android Studio / VS Code
- iOS development setup (for iOS deployment)
- Android development setup (for Android deployment)

## 🛠️ Dependencies

### Main Dependencies
- **State Management**: `vanilla_state: ^1.1.0+1`
- **Networking**: `dio: ^5.8.0+1`
- **Routing**: `go_router: ^14.8.1`
- **Local Storage**: `hive_flutter: ^1.1.0`
- **UI Components**:
  - `flutter_screenutil: ^5.9.3`
  - `google_fonts: ^6.2.1`
  - `flutter_svg: ^2.0.17`
- **Authentication**:
  - `google_sign_in: ^6.3.0`
  - `flutter_facebook_auth: ^7.1.1`
- **Media**:
  - `youtube_player_flutter: ^9.1.1`
  - `just_audio: ^0.10.2`
  - `just_audio_background: ^0.0.1-beta.16`

### Development Dependencies
- `flutter_lints: ^5.0.0`
- `flutter_test`

## 📁 Project Structure

```
lib/
├── main.dart
└── src/
    ├── core/       # Core functionality and utilities
    ├── modules/    # Feature modules
    └── tools/      # Helper tools and utilities
```

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd jima
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create a `.env` file in the `assets/env/` directory
   - Add required configuration variables

4. **Run the application**
   ```bash
   flutter run
   ```

## 🔑 Environment Configuration

Create a `.env` file in `assets/env/` with the following variables:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_CLIENT_ID=your_google_client_id
FACEBOOK_CLIENT_ID=your_facebook_client_id
```

## 📱 Supported Platforms

- iOS
- Android

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Initial work - [Author Name]

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors who have helped this project grow
