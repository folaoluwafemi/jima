import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/modules/_onboarding/presentation/cubits/splash_notifier.dart';
import 'package:jima/src/tools/constants/images.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:vanilla_state/vanilla_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => SplashNotifier()..loadApp(context),
      child: VanillaListener<SplashNotifier, SplashState>(
        listener: (previous, current) {
          if (current.data != null) context.goNamed(current.data!.name);
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 270),
                    Images.jim.imageAssetWidget(
                      width: context.screenWidth(),
                      height: 179.h,
                    ),
                    const Spacer(flex: 425),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 692),
                    SizedBox.square(
                      dimension: 56.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 6.sp,
                      ),
                    ),
                    16.boxHeight,
                    Text(
                      'Loading...',
                      style: GoogleFonts.lexend(
                        height: 1.25,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(flex: 90),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
