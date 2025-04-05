import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/auth_action_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class AuthActionScreen extends StatelessWidget {
  const AuthActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => AuthActionNotifier(container()),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.glassBlack,
          body: Stack(
            children: [
              Images.jimaPastorImage.imageAssetWidget(
                height: context.screenHeight(),
                width: context.screenWidth(),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    transform: GradientRotation(90.toRadians),
                    colors: [
                      AppColors.black.withAlpha((255.0 * 0).round()),
                      AppColors.black.withAlpha((255.0 * 0.8).round()),
                      AppColors.black,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Images.jim.imageAssetWidget(
                      height: 179.h,
                      width: 318.w,
                    ),
                    56.boxHeight,
                    VanillaListener<AuthActionNotifier, AuthActionState>(
                      listener: (previous, current) => handleErrorCase(
                        previous,
                        current,
                        context: context,
                        callback: (previous, current) {
                          if (current.isSuccess) {
                            context.goNamed(AppRoute.dashboard.name);
                          }
                        },
                      ),
                      child:
                          VanillaBuilder<AuthActionNotifier, AuthActionState>(
                        builder: (context, state) {
                          return Padding(
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton.white(
                                        onPressed: () => context.goNamed(
                                          AppRoute.login.name,
                                        ),
                                        text: 'Sign In',
                                      ),
                                    ),
                                    16.boxWidth,
                                    Expanded(
                                      child: AppButton.primary(
                                        onPressed: () => context.goNamed(
                                          AppRoute.signup.name,
                                        ),
                                        text: 'Sign Up',
                                      ),
                                    ),
                                  ],
                                ),
                                16.boxHeight,
                                AppButton.outlined(
                                  loading: state.isOutLoading,
                                  onPressed: context
                                      .read<AuthActionNotifier>()
                                      .loginWithGoogle,
                                  text: 'Continue with Google',
                                  icon: Vectors.google.vectorAssetWidget(),
                                ),
                                16.boxHeight,
                                AppButton.outlined(
                                  loading: state.isInLoading,
                                  onPressed: context
                                      .read<AuthActionNotifier>()
                                      .loginWithFacebook,
                                  text: 'Continue with Facebook',
                                  icon: Vectors.facebook.vectorAssetWidget(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    56.boxHeight,
                    Text.rich(
                      TextSpan(
                        text: 'By continuing, I agree to ',
                        children: [
                          TextSpan(
                            text: 'Terms of Conditions',
                            style: Textstyles.medium.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.white,
                              color: AppColors.white,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: '\nPrivacy of Policy',
                            style: Textstyles.medium.copyWith(
                              decorationColor: AppColors.white,
                              decoration: TextDecoration.underline,
                              color: AppColors.white,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: Textstyles.medium.copyWith(
                        color: AppColors.white,
                        height: 1.5,
                      ),
                    ),
                    40.boxHeight,
                    context.bottomScreenPadding.boxHeight,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
