import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/navigation/home_observer.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/_onboarding/presentation/screens/onboarding_screen.dart';
import 'package:jima/src/modules/_onboarding/presentation/screens/splash_screen.dart';
import 'package:jima/src/modules/admin/presentation/screens/admin_screen.dart';
import 'package:jima/src/modules/admin/presentation/screens/upload_audio_screen.dart';
import 'package:jima/src/modules/admin/presentation/screens/upload_books_screen.dart';
import 'package:jima/src/modules/admin/presentation/screens/upload_video_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/auth_action_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/forgot_password_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/login_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/signup_screen.dart';
import 'package:jima/src/modules/donate/presentation/donation_screen.dart';
import 'package:jima/src/modules/media/domain/entities/audio.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:jima/src/modules/media/domain/entities/video.dart';
import 'package:jima/src/modules/media/presentations/screens/all_media_search_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/audio_player_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/audio_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/book_preview_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/books_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/dashboard_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/video_preview_screen.dart';
import 'package:jima/src/modules/media/presentations/screens/videos_screen.dart';
import 'package:jima/src/modules/profile/presentation/screens/profile_screen.dart';
import 'package:jima/src/tools/components/bottom_nav.dart';

abstract final class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter config = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        name: AppRoute.splash.name,
        path: AppRoute.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoute.onboarding.name,
        path: AppRoute.onboarding.path,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: AppRoute.authAction.name,
        path: AppRoute.authAction.path,
        builder: (context, state) => const AuthActionScreen(),
        routes: [
          GoRoute(
            name: AppRoute.login.name,
            path: AppRoute.login.path,
            builder: (context, state) => const LoginScreen(),
            routes: [
              GoRoute(
                name: AppRoute.forgotPassword.name,
                path: AppRoute.forgotPassword.path,
                builder: (context, state) => const ForgotPasswordScreen(),
              ),
            ],
          ),
          GoRoute(
            name: AppRoute.signup.name,
            path: AppRoute.signup.path,
            builder: (context, state) => const SignupScreen(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: homeNavigatorKey,
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        observers: [HomeRouteObserver()],
        routes: [
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.dashboard.name,
            path: AppRoute.dashboard.path,
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: AppRoute.allMediaSearch.path,
                name: AppRoute.allMediaSearch.name,
                builder: (context, state) => const AllMediaSearchScreen(),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.videos.name,
            path: AppRoute.videos.path,
            builder: (context, state) => const VideosScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.videoPreview.name,
                path: AppRoute.videoPreview.path,
                builder: (context, state) => VideoPreviewScreen(
                  video: state.extra as Video,
                ),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.audios.name,
            path: AppRoute.audios.path,
            builder: (context, state) => const AudiosScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.audioPreview.name,
                path: AppRoute.audioPreview.path,
                builder: (context, state) => AudioPlayerScreen(
                  audio: state.extra as Audio,
                ),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.books.name,
            path: AppRoute.books.path,
            builder: (context, state) => const BooksScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.bookPreview.name,
                path: AppRoute.bookPreview.path,
                builder: (context, state) => BookPreviewScreen(
                  book: state.extra as Book,
                ),
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.profile.name,
            path: AppRoute.profile.path,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.donation.name,
            path: AppRoute.donation.path,
            builder: (context, state) => const DonationScreen(),
          ),
          GoRoute(
            parentNavigatorKey: homeNavigatorKey,
            name: AppRoute.admin.name,
            path: AppRoute.admin.path,
            builder: (context, state) => const AdminScreen(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.uploadAudio.name,
                path: AppRoute.uploadAudio.path,
                builder: (context, state) => const UploadAudioScreen(),
              ),
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.uploadBook.name,
                path: AppRoute.uploadBook.path,
                builder: (context, state) => const UploadBooksScreen(),
              ),
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                name: AppRoute.uploadVideo.name,
                path: AppRoute.uploadVideo.path,
                builder: (context, state) => const UploadVideoScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
