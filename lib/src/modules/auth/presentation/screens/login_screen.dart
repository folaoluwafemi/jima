import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/login_notifier.dart';
import 'package:jima/src/tools/components/password_field.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => LoginNotifier(container()),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            13.boxHeight,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Sign In',
                style: Textstyles.bold.copyWith(
                  color: AppColors.textBlack,
                  fontSize: 32,
                ),
              ),
            ),
            42.boxHeight,
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
                    12.boxHeight,
                    PasswordTextField(
                      labelText: 'Password',
                      controller: passwordController,
                    ),
                    12.boxHeight,
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => context.goNamed(
                          AppRoute.forgotPassword.name,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: Textstyles.normal.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                    ),
                    32.boxHeight,
                    VanillaListener<LoginNotifier, LoginState>(
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
                      child: VanillaBuilder<LoginNotifier, LoginState>(
                        builder: (context, state) {
                          return AppButton.primary(
                            loading: state.isOutLoading,
                            onPressed: () {
                              final validated =
                                  formKey.currentState?.validate();
                              if (validated != true) return;
                              context.hideKeyboard();
                              context.read<LoginNotifier>().login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                            },
                            text: 'Login',
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
