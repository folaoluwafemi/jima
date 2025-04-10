import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/tools/tools_barrel.dart';

final class HomeRouteObserver extends NavigatorObserver {
  HomeRouteObserver._();

  static final instance = HomeRouteObserver._();

  factory HomeRouteObserver() => instance;

  final ValueNotifier<AppRoute> routeNotifier = ValueNotifier(
    AppRoute.dashboard,
  );

  void _updateCurrentRoute(Route<dynamic> currentRoute) {
    final AppRoute route = AppRoute.fromRouteName(
      currentRoute.settings.name?.nullIfEmpty ?? '/onboarding',
    );

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (route == routeNotifier.value) return;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      routeNotifier.value = route;
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute == null) return;
    _updateCurrentRoute(previousRoute);
  }

  @override
  void didReplace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateCurrentRoute(newRoute!);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateCurrentRoute(route);
  }
}
