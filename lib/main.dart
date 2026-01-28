import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'core/router/app_router.dart';
import 'services/tts_service.dart';
import 'services/tts_service.dart';
import 'services/user_progress_service.dart';
import 'services/prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const KidsLearningApp());
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Services globally
    return MultiProvider(
      providers: [
        Provider<TtsService>(create: (_) => TtsService()..init()),
        ChangeNotifierProvider<UserProgressService>(create: (_) => UserProgressService()..init()),
        ChangeNotifierProvider<PrefsService>(create: (_) => PrefsService()..init()),
      ],
      child: MaterialApp.router(
        title: 'Kids Learning Flashcards',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        
        // Navigation 2.0 Configuration
        routerConfig: AppRouter.router,
      ),
    );
  }
}
