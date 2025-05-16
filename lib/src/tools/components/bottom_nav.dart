import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/home_observer.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:jima/src/tools/tools_barrel.dart';

enum BottomNavItem {
  dashboard(AppRoute.dashboard, Vectors.dashboard),
  videos(AppRoute.videos, Vectors.videos),
  audios(AppRoute.audios, Vectors.audios),
  books(AppRoute.books, Vectors.books),
  give(AppRoute.donation, Vectors.donation),
  profile(AppRoute.profile, Vectors.profile),
  ;

  final AppRoute route;
  final String assetPath;

  Future<void> resolveAction(BuildContext context) async {
    if (this == profile) {
      if (container<UserNotifier>().userPrivilege.isNone) {
        context.showErrorToast('You don\'t have the privilege to access this page');
        return;
      }
      return container<UserNotifier>().userPrivilege.isAdmin
          ? context.goNamed(AppRoute.admin.name)
          : context.goNamed(route.name);
    }
    context.goNamed(route.name);
  }

  const BottomNavItem(this.route, this.assetPath);

  bool get shouldBeRemoved {
    if (this != profile) return false;

    return container<UserNotifier>().userPrivilege.isNone;
  }

  factory BottomNavItem.fromRoute(AppRoute route) {
    return values.firstWhere(
      (element) => element.route == route,
      orElse: () => route == AppRoute.admin ? profile : dashboard,
    );
  }
}

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const BottomNav(),
      ],
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(bottom: context.bottomScreenPadding),
      child: Material(
        color: AppColors.offWhite,
        child: ValueListenableBuilder<AppRoute>(
          valueListenable: HomeRouteObserver().routeNotifier,
          builder: (context, route, _) {
            final selectedItem = BottomNavItem.fromRoute(route);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                11.boxWidth,
                ...BottomNavItem.values
                    .copyRemoveWhere((e) => e.shouldBeRemoved)
                    .map(
                  (item) {
                    final selected = item == selectedItem;
                    return RawMaterialButton(
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (selected) return;
                        item.resolveAction(context);
                      },
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      child: Padding(
                        padding: REdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: 8,
                        ),
                        child: SizedBox(
                          width: 48.w,
                          child: Column(
                            children: [
                              item.assetPath.vectorAssetWidget(
                                dimension: 24.sp,
                                color: selected
                                    ? AppColors.blue
                                    : AppColors.bottomNavText,
                              ),
                              3.boxHeight,
                              FittedBox(
                                child: Text(
                                  container<UserNotifier>()
                                              .userPrivilege
                                              .isAdmin &&
                                          item == BottomNavItem.profile
                                      ? 'Admin'
                                      : item.name.toFirstUppercase(),
                                  style: Textstyles.normal.copyWith(
                                    color: selected
                                        ? AppColors.blue
                                        : AppColors.bottomNavText,
                                    fontSize: 10.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                11.boxWidth,
              ],
            );
          },
        ),
      ),
    );
  }
}
