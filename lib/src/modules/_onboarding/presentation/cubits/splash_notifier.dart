import 'package:flutter/widgets.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef SplashState = BaseState<AppRoute?>;

class SplashNotifier extends BaseNotifier<AppRoute?> {
  SplashNotifier() : super(const InitialState());

  Future<void> loadApp(BuildContext context) async {
    // TODO: fetch locally stored user
    await precacheImage(const AssetImage(Images.jimaPastorImage), context);
    await Future.delayed(const Duration(milliseconds: 2000));
    setData(AppRoute.authAction);
  }
}
