import 'package:flutter/widgets.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef SplashState = BaseState<AppRoute?>;

class SplashNotifier extends BaseNotifier<AppRoute?> {
  SplashNotifier() : super(const InitialState());

  Future<void> loadApp(BuildContext context) async {
    await precacheImage(const AssetImage(Images.jimaPastorImage), context);
    final authenticated = container<SupabaseAuthService>().currentState?.id == null;
    if (authenticated) return setData(AppRoute.authAction);

    await container<UserNotifier>().fetchUser();
    final user = container<UserNotifier>().data;

    if (user != null) return setData(AppRoute.dashboard);

    return setData(AppRoute.authAction);
  }
}
