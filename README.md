# 🎨 Kids Learning Flashcards App

A playful, child-friendly mobile application built with Flutter to help kids learn through interactive flashcards.

## 📚 Project Overview

This is a college lab project (MAD - Mobile Application Development) focused on creating an engaging educational app for children. The app uses flashcards as the primary learning method with a bright, colorful interface designed specifically for young learners.

## ✨ Features (Planned)

- 📇 Interactive flashcard system
- 🎨 Playful & bright UI with kid-friendly colors
- ✍️ Custom typography using Google Fonts (Fredoka)
- 📱 Clean, scalable architecture
- 🎯 Multiple learning categories

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core functionality
│   ├── theme/
│   │   └── theme.dart                 # App-wide theme configuration
│   ├── constants/
│   │   └── app_constants.dart         # App constants
│   └── utils/
│       └── helpers.dart               # Utility functions
├── features/                          # Feature-based modules
│   ├── flashcards/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── models/
│   └── home/
│       ├── screens/
│       └── widgets/
├── shared/                            # Shared components
│   └── widgets/
└── services/                          # Services layer
```

## 🎨 Design System

### Color Palette
- **Primary:** Pastel Orange (#FFB347) - Evokes enthusiasm and creativity
- **Secondary:** Mint Green (#98D8C8) - Represents growth and harmony
- **Accent:** Soft Blue (#6FB3E0) - Enhances focus and concentration
- **Background:** Warm Off-White (#FFF8F0) - Easy on children's eyes

### Typography
- **Font Family:** Fredoka (Google Fonts)
- **Style:** Rounded, friendly, and highly readable for kids

### UI Components
- **AppBar:** Centered title, zero elevation, clean design
- **Input Fields:** Rounded corners (12px), colorful focus states
- **Buttons:** Rounded, elevated with playful colors
- **Cards:** Subtle shadow, 16px border radius

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd MAD-kids-learning-from-flashcard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Testing the Theme

When you first run the app, you'll see a **Placeholder Screen** that demonstrates:
- ✅ Google Fonts loading (Fredoka typography)
- ✅ Color palette application
- ✅ AppBar styling
- ✅ Input field styling
- ✅ Button themes
- ✅ Card components

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0              # Custom typography
  cupertino_icons: ^1.0.2           # iOS-style icons

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0             # Code quality checks
```

## 🎓 Lab Report Notes

### Design Decisions

1. **Color Choice Rationale:**
   - Orange: Stimulates enthusiasm and creativity
   - Green: Promotes calmness and reduces learning anxiety
   - Blue: Improves focus and concentration
   - Pastel tones: Reduces eye strain for extended use

2. **Font Selection (Fredoka):**
   - Rounded letterforms appeal to children
   - High readability at various sizes
   - Playful yet professional appearance

3. **Architecture Pattern:**
   - Feature-based organization for scalability
   - Clear separation of concerns
   - Easy to add new learning modules

4. **UI/UX Principles:**
   - Large tap targets for small fingers
   - High contrast for readability
   - Minimal text, maximum visual feedback
   - Rounded corners for friendly appearance

## 🔧 Development Guidelines

### Adding New Features
1. Create a new folder in `lib/features/`
2. Follow the structure: `screens/`, `widgets/`, `models/`
3. Use the theme system for consistent styling

### Code Style
- Follow Flutter/Dart conventions
- Add comments for complex logic
- Use meaningful variable names
- Keep widgets small and focused

## 📝 TODO

- [ ] Implement flashcard flip animation
- [ ] Add multiple categories (Math, Alphabet, Animals, etc.)
- [ ] Implement local storage for flashcards
- [ ] Add progress tracking
- [ ] Create flashcard creation/editing interface
- [ ] Add sound effects and animations

## 👥 Contributors

- [Your Name] - Initial work & theme design

## 📄 License

This project is created for educational purposes as part of college coursework.

## 🙏 Acknowledgments

- Google Fonts for providing beautiful, free fonts
- Flutter team for the amazing framework
- Inspiration from various kids learning apps