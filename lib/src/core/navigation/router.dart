import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/_onboarding/presentation/screens/onboarding_screen.dart';
import 'package:jima/src/modules/_onboarding/presentation/screens/splash_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/auth_action_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/forgot_password_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/login_screen.dart';
import 'package:jima/src/modules/auth/presentation/screens/signup_screen.dart';

abstract final class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

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
    ],
  );
}
