import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/forgot_password_notifier.dart';
import 'package:jima/src/tools/components/password_field.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => ForgotPasswordNotifier(container()),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              13.boxHeight,
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Create a new\nPassword',
                  style: Textstyles.bold.copyWith(
                    color: AppColors.textBlack,
                    fontSize: 32,
                  ),
                ),
              ),
              35.boxHeight,
              Form(
                key: formKey,
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PasswordTextField(controller: passwordController),
                      32.boxHeight,
                      ListenableBuilder(
                        listenable: passwordController,
                        builder: (context, _) {
                          return PasswordTextField(
                            labelText: 'Confirm Password',
                            controller: confirmPasswordController,
                            hintText: 'Enter your password again',
                            validator: (value) {
                              if (value.isNullOrEmpty) return 'Field is required';
                              if (value == passwordController.text) return null;
                              return 'Passwords do not match';
                            },
                          );
                        },
                      ),
                      48.boxHeight,
                      VanillaListener<ForgotPasswordNotifier,
                          ForgotPasswordState>(
                        listener: (previous, current) => handleErrorCase(
                          previous,
                          current,
                          context: context,
                          callback: (previous, current) {
                            if (current.isSuccess) {
                              context.showSuccessToast(
                                'Password Changed successfully',
                              );
                              context.goNamed(AppRoute.dashboard.name);
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
                                    .changePassword(
                                      passwordController.text.trim(),
                                    );
                              },
                              text: 'Done',
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
      ),
    );
  }
}
