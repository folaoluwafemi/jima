import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/forgot_password_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => ForgotPasswordNotifier(container()),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            13.boxHeight,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password',
                    style: Textstyles.bold.copyWith(
                      color: AppColors.textBlack,
                      fontSize: 32,
                    ),
                  ),
                  10.boxHeight,
                  Text(
                    'Enter your email address and a reset otp\n will be sent to you.\n\n',
                    style: Textstyles.normal.copyWith(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField.email(
                      labelText: 'Email Address',
                      controller: emailController,
                    ),
                    32.boxHeight,
                    VanillaListener<ForgotPasswordNotifier,
                        ForgotPasswordState>(
                      listener: (previous, current) => handleErrorCase(
                        previous,
                        current,
                        context: context,
                        callback: (previous, current) {
                          if (current.isSuccess) {
                            context.pushNamed(
                              AppRoute.forgotPasswordOtp.name,
                              extra: emailController.text,
                            );
                          }
                        },
                      ),
                      child: VanillaBuilder<ForgotPasswordNotifier,
                          ForgotPasswordState>(
                        builder: (context, state) {
                          return AppButton.primary(
                            loading: state.isOutLoading,
                            onPressed: () {
                              final validated =
                                  formKey.currentState?.validate();
                              if (validated != true) return;
                              context.hideKeyboard();
                              context
                                  .read<ForgotPasswordNotifier>()
                                  .sendResetInstructions(
                                    emailController.text.trim(),
                                  );
                            },
                            text: 'Reset',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
