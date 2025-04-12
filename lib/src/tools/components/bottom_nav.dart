import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/home_observer.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/tools/tools_barrel.dart';

enum BottomNavItem {
  dashboard(AppRoute.dashboard, Vectors.profile),
  videos(AppRoute.videos, Vectors.videos),
  audios(AppRoute.audios, Vectors.dashboard),
  books(AppRoute.books, Vectors.books),
  donate(AppRoute.donation, Vectors.donation),
  profile(AppRoute.profile, Vectors.audios),
  ;

  final AppRoute route;
  final String assetPath;

  const BottomNavItem(this.route, this.assetPath);

  factory BottomNavItem.fromRoute(AppRoute route) {
    return values.firstWhere(
      (element) => element.route == route,
      orElse: () => dashboard,
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
                ...BottomNavItem.values.map(
                  (item) {
                    final selected = item == selectedItem;
                    return RawMaterialButton(
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (selected) return;
                        context.goNamed(item.route.name);
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
                                  item.name.toFirstUppercase(),
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
